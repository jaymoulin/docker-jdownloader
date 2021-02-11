VERSION ?= 1.4.3
CACHE ?= --no-cache=1
FULLVERSION ?= ${VERSION}
archs ?= amd64 arm32v6 armhf arm64v8

.PHONY: all build publish latest
all: build publish latest
qemu-arm-static:
	cp /usr/bin/qemu-arm-static .
qemu-aarch64-static:
	cp /usr/bin/qemu-aarch64-static .
build: qemu-arm-static qemu-aarch64-static
	$(foreach arch,$(archs), \
		FILE=Dockerfile; \
		if [ $(arch) = amd64 ]; \
			then archi=$(arch); \
			image=bellsoft\\/liberica-openjdk-alpine:10-x86_64; \
		elif [ $(arch) = arm32v6 ]; \
			then archi=armel; \
			image=balenalib\\/raspberry-pi; \
			FILE=debian.Dockerfile; \
		elif [ $(arch) = armhf ]; \
			then archi=$(arch); \
			image=bellsoft\\/liberica-openjdk-alpine:10-armv7l; \
		else \
			archi=arm64; \
			image=bellsoft\\/liberica-openjdk-alpine:10-aarch64; \
		fi; \
		cat $$FILE | sed "s/FROM openjdk:jre-alpine/FROM $$image/g" > .Dockerfile; \
		docker build -t jaymoulin/jdownloader:${VERSION}-$(arch) -f .Dockerfile --build-arg ARCH=$${archi} ${CACHE} --build-arg VERSION=${VERSION} .;\
	)
publish:
	docker push jaymoulin/jdownloader -a
	cat manifest.yml | sed "s/\$$VERSION/${VERSION}/g" > manifest.yaml
	cat manifest.yaml | sed "s/\$$FULLVERSION/${FULLVERSION}/g" > manifest2.yaml
	mv manifest2.yaml manifest.yaml
	manifest-tool push from-spec manifest.yaml
latest: build
	FULLVERSION=latest VERSION=${VERSION} make publish
