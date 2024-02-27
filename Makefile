VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
REGISTRY=aripak

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
	APP=kbot.git
else
	APP=$(shell basename $(shell git remote get-url origin))
endif

ifeq ($(OS),windows)
	TARGETARCH=x64
else
	TARGETARCH=$(shell dpkg --print-architecture)
endif

format: 
	gofmt -s -w ./

vet:
ifeq ($(OS), windows) 
	go vet -all
else 
	$(shell go vet)
endif

test: 
	go test -v 

# old function golint
#lint:
#	golint

get:
	go get

build: format get 
ifeq ($(OS),windows)
	go build -v -o kbot.exe -ldflags "-X 'github.com/AlbertRipak/kbot/cmd.appVersion=${VERSION}'"
else
	CGO_ENABLED=0 GOOS=${OS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X 'github.com/AlbertRipak/kbot/cmd.appVersion=${VERSION}'"
endif

image: 
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

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

####################### make linux #######################
linux: format vet test get build image push clean

####################### make arch ########################
arch: format vet test get build image push clean

####################### make macos #######################
macos: format vet test get build image push clean