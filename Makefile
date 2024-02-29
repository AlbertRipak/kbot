VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
REGISTRY=quay.io/albertripak
UNAME:=$(shell uname -s)
OS:=$(Get-ChildItem Env:PROCESSOR_ARCHITECTURE)

ifeq ($(OS),Windows_NT)
	APP=kbot
else
	APP=$(shell basename $(shell git remote get-url origin))
endif

ifeq ($(OS),Windows_NT)
	TARGETARCH=x64
else ifeq ($(UNAME),Linux)
	TARGETARCH=$(shell dpkg --print-architecture)
else 
$(error OS not supported by this Makefile)
endif

.PHONY: format
format: 
	gofmt -s -w ./

.PHONY: vet
vet:
	go vet -all

.PHONY: test
test: 
	go test -v

.PHONY: get
get:
	go get

build: 
ifeq ($(OS),Windows_NT)
	go build -v -o kbot -ldflags "-X=github.com/AlbertRipak/kbot/cmd.appVersion=${VERSION}-${TARGETARCH}"
else
	CGO_ENABLED=0 GOOS=${OS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X=github.com/AlbertRipak/kbot/cmd.appVersion=${VERSION}-${TARGETARCH}"
endif

image: 
ifeq ($(OS),Windows_NT)
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .
else ifeq ($(UNAME),Linux)
	docker build --build-arg BUILDPLATFORM=linux/amd64 -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .
else ifeq ($(UNAME),Darwin)
	docker build --build-arg BUILDPLATFORM=linux/amd64 -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .	
else 
$(docker build --build-arg BUILDPLATFORM=linux/arm64 -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .) 
endif

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

.PHONY: clean
clean:  
ifeq ($(OS),windows)
	del .\kbot*
else 
	rm -rf kbot*
endif

###################### make windows ######################
windows: format vet test get build image push clean
	docker run -e TARGETPLATFORM=windows/amd64 --name ${APP}_${VERSION}-${TARGETARCH} ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
	docker rmi --force ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

####################### make linux #######################
linux: format vet test get build image push clean 
	docker run -e TARGETPLATFORM=linux/amd64 --name ${APP}_${VERSION}-${TARGETARCH} ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
	docker rm ${APP}_${VERSION}-${TARGETARCH}
	docker rmi --force ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

######################## make arm ########################
arm: format vet test get build image push clean
	docker run -e TARGETPLATFORM=linux/arm64 kbot
	docker rm ${APP}_${VERSION}-${TARGETARCH}
	docker rmi --force ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

####################### make macos #######################
macos: format vet test get build image push clean
	docker run -e TARGETPLATFORM=linux/amd64 test-kbot
	docker rmi --force ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

