FROM openjdk:jre-alpine as builder

COPY qemu-aarch64-static /usr/bin/
COPY qemu-arm-static /usr/bin/

FROM builder

ARG ARCH=armhf
ARG VERSION="0.7.0"
LABEL maintainer="Jay MOULIN <jaymoulin@gmail.com> <https://twitter.com/MoulinJay>"
LABEL version="${VERSION}-${ARCH}"

COPY ./${ARCH}/*.jar /opt/JDownloader/libs/
# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
RUN mkdir -p /opt/JDownloader/ && \
    apk add --update libstdc++ ffmpeg && \
    apk add wget  --virtual .build-deps && \
    wget -O /opt/JDownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && \
    chmod +x /opt/JDownloader/JDownloader.jar && \
    chmod 777 /opt/JDownloader/ -R && \
    apk add --no-cache tini-static && \
    apk del wget --purge .build-deps && \
    rm /usr/bin/qemu-*-static


COPY daemon.sh /opt/JDownloader/
COPY default-config.json.dist /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
COPY configure.sh /usr/bin/configure

WORKDIR /opt/JDownloader

CMD ["tini-static", "--", "/opt/JDownloader/daemon.sh"]
