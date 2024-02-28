VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
REGISTRY=quay.io/albertripak

# Get-ChildItem Env:PROCESSOR_ARCHITECTURE

ifeq ($(OS),Windows_NT)
	OS = windows
else 
	UNAME := $(shell uname -s)
	ifeq ($(UNAME),Darwin)
		OS = macos
	else ifeq ($(UNAME),Linux)
		OS = linux 
	else 
		$(error OS not supported by this Makefile)
	endif 
endif

ifeq ($(OS),windows)
	APP=kbot
else
	APP=$(shell basename $(shell git remote get-url origin))
endif

ifeq ($(OS),windows)
TARGETARCH=x64
else
TARGETARCH=$(shell dpkg --print-architecture)
endif

format: 
ifeq ($(OS), windows) 
	gofmt -s -w ./
else 
	$(shell gofmt -s -w ./)
endif

vet:
ifeq ($(OS), windows) 
	go vet -all
else 
	$(shell go vet)
endif

test: 
ifeq ($(OS), windows) 
	go test -v
else 
	$(shell go test -v)
endif

get:
ifeq ($(OS), windows) 
	go get
else 
	$(shell go get)
endif

build: format get 
ifeq ($(OS),windows)
	go build -v -o kbot.exe -ldflags "-X 'github.com/AlbertRipak/kbot/cmd.appVersion=${VERSION}'"
else
	CGO_ENABLED=0 GOOS=${OS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X 'github.com/AlbertRipak/kbot/cmd.appVersion=${VERSION}'"
endif

image: 
ifeq ($(OS),windows)
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .
else 
	UNAME := $(shell uname -s)
	ifeq ($(UNAME),Darwin)
		docker build --build-arg BUILDPLATFORM=linux/amd64 -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .
	else ifeq ($(UNAME),Linux)
		docker build --build-arg BUILDPLATFORM=linux/amd64 -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .
	else 
		docker build --build-arg BUILDPLATFORM=linux/arm64 -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .
	endif 
endif

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

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
	docker run -e TARGETPLATFORM=linux/amd64 kbot
	docker rmi --force ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

######################## make arm ########################
arm: format vet test get build image push clean
	docker run -e TARGETPLATFORM=linux/arm64 kbot
	docker rmi --force ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

####################### make macos #######################
macos: format vet test get build image push clean
	ocker run -e TARGETPLATFORM=linux/amd64 test-kbot
	docker rmi --force ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}