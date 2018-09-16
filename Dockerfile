FROM openjdk:jre-alpine as builder

COPY qemu-aarch64-static /usr/bin/
COPY qemu-arm-static /usr/bin/

FROM builder

ARG ARCH=armhf
ARG VERSION="0.5.1"
LABEL maintainer="Jay MOULIN <jaymoulin@gmail.com> <https://twitter.com/MoulinJay>"
LABEL version="${VERSION}"

COPY ./${ARCH}/*.jar /opt/JDownloader/libs/
# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
RUN mkdir -p /opt/JDownloader/ && \
    apk add --update libstdc++ ffmpeg && apk add wget  --virtual .build-deps && \
    wget -O /opt/JDownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && \
    chmod +x /opt/JDownloader/JDownloader.jar && \
    wget -O /usr/bin/tini "https://github.com/krallin/tini/releases/download/v0.18.0/tini-static-${ARCH}" --no-check-certificate \
    && chmod +x /usr/bin/tini && \
    apk del wget --purge .build-deps && \
    rm /usr/bin/qemu-*-static
ENV LD_LIBRARY_PATH=/lib;/lib32;/usr/lib

COPY daemon.sh /opt/JDownloader/
COPY default-config.json.dist /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
COPY configure.sh /usr/bin/configure

VOLUME /root/Downloads
VOLUME /opt/JDownloader/cfg
WORKDIR /opt/JDownloader

CMD ["tini", "--", "/opt/JDownloader/daemon.sh"]
