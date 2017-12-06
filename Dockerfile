FROM openjdk:jre-alpine as builder

COPY qemu-*-static /usr/bin/

FROM builder

ARG ARCH=armhf
LABEL maintainer="Jay MOULIN <jaymoulin@gmail.com> <https://twitter.com/MoulinJay>"

# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
RUN mkdir -p /opt/JDownloader/
RUN apk add --update libstdc++ ffmpeg && apk add wget  --virtual .build-deps && \
    wget -O /opt/JDownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && chmod +x /opt/JDownloader/JDownloader.jar && \
    wget -O /usr/bin/tini "https://github.com/krallin/tini/releases/download/v0.16.1/tini-static-${ARCH}" --no-check-certificate && chmod +x /usr/bin/tini && \
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
