VERSION ?= 0.4.2
CACHE ?= --no-cache=1
FULLVERSION ?= ${VERSION}
archs = amd64 arm32v6 arm64v8 i386

.PHONY: all build publish latest
all: build publish latest
build:
	rm qemu-*-static
	cp /usr/bin/qemu-arm-static .
	cp /usr/bin/qemu-aarch64-static .
	$(foreach arch,$(archs), \
		if [ $(arch) = arm32v6 ]; then archi=armhf; elif [ $(arch) = arm64v8 ]; then archi=arm64; else archi=$(arch); fi; \
		cat Dockerfile | sed "s/FROM openjdk:jre-alpine/FROM ${arch}\/openjdk:jre-alpine/g" > .Dockerfile; \
		docker build -t jaymoulin/jdownloader:${VERSION}-$(arch) -f .Dockerfile --build-arg ARCH=$${archi} ${CACHE} .;\
	)
publish:
	docker push jaymoulin/jdownloader
	cat manifest.yml | sed "s/\$$VERSION/${VERSION}/g" > manifest.yaml
	cat manifest.yaml | sed "s/\$$FULLVERSION/${FULLVERSION}/g" > manifest2.yaml
	mv manifest2.yaml manifest.yaml
	manifest-tool push from-spec manifest.yaml
latest: build
	FULLVERSION=latest VERSION=${VERSION} make publish
