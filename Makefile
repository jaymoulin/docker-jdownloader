VERSION ?= 1.0.0
CACHE ?= --no-cache=1
FULLVERSION ?= ${VERSION}
archs ?= amd64 arm32v6 armhf arm64v8 i386

.PHONY: all build publish latest
all: build publish latest
qemu-arm-static:
	cp /usr/bin/qemu-arm-static .
qemu-aarch64-static:
	cp /usr/bin/qemu-aarch64-static .
build: qemu-arm-static qemu-aarch64-static
	$(foreach arch,$(archs), \
		FILE=Dockerfile; \
		if [ $(arch) = armhf ]; \
			then archi=armhf; \
			image=jaymoulin\\/oracle-jdk:armhf; \
		elif [ $(arch) = arm64v8 ]; \
			then archi=arm64; \
			image=${arch}\\/openjdk:jre-alpine; \
		elif [ $(arch) = arm32v6 ]; \
			then archi=armel; \
			FILE=Dockerfile.arm32v6; \
		else \
			archi=$(arch); \
			image=${arch}\\/openjdk:jre-alpine; \
		fi; \
		cat $$FILE | sed "s/FROM openjdk:jre-alpine/FROM $$image/g" > .Dockerfile; \
		docker build -t jaymoulin/jdownloader:${VERSION}-$(arch) -f .Dockerfile --build-arg ARCH=$${archi} ${CACHE} --build-arg VERSION=${VERSION} .;\
	)
publish:
	docker push jaymoulin/jdownloader
	cat manifest.yml | sed "s/\$$VERSION/${VERSION}/g" > manifest.yaml
	cat manifest.yaml | sed "s/\$$FULLVERSION/${FULLVERSION}/g" > manifest2.yaml
	mv manifest2.yaml manifest.yaml
	manifest-tool push from-spec manifest.yaml
latest: build
	FULLVERSION=latest VERSION=${VERSION} make publish
