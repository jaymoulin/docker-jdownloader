FROM openjdk:jre-alpine as builder

COPY qemu-aarch64-static /usr/bin/
COPY qemu-arm-static /usr/bin/

FROM builder

ARG ARCH=armhf
ARG VERSION="1.4.2"
LABEL maintainer="Jay MOULIN <https://jaymoulin.me/me/docker-jdownloader> <https://twitter.com/MoulinJay>"
LABEL version="${VERSION}-${ARCH}"
ENV LD_LIBRARY_PATH=/lib;/lib32;/usr/lib
ENV XDG_DOWNLOAD_DIR=/opt/JDownloader/Downloads
ENV UMASK=''

COPY ./${ARCH}/*.jar /opt/JDownloader/libs/
# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
RUN mkdir -p /opt/JDownloader/ && \
    apk add --update libstdc++ ffmpeg wget && \
    wget -O /opt/JDownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && \
    chmod +x /opt/JDownloader/JDownloader.jar && \
    chmod 777 /opt/JDownloader/ -R && \
    rm /usr/bin/qemu-*-static

COPY daemon.sh /opt/JDownloader/
COPY default-config.json.dist /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
COPY configure.sh /usr/bin/configure

EXPOSE 3129
WORKDIR /opt/JDownloader

VOLUME /opt/JDownloader

CMD ["/opt/JDownloader/daemon.sh"]
