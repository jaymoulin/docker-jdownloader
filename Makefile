VERSION ?= 2.2.0
CACHE ?= --no-cache=1

.PHONY: all build publish
all: build publish
build:
	docker buildx build --platform linux/arm/v6,linux/arm/v7,linux/arm64/v8,linux/amd64 ${PUSH} --build-arg VERSION=${VERSION} --tag jaymoulin/jdownloader --tag jaymoulin/jdownloader:${VERSION} ${CACHE} .
publish:
	PUSH=--push CACHE= make build

