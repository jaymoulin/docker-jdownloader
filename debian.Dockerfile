FROM openjdk:jre-alpine as builder

COPY qemu-arm-static /usr/bin/
COPY qemu-aarch64-static /usr/bin/

FROM builder

ARG ARCH=armel
ARG VERSION="1.4.2"
LABEL maintainer="Jay MOULIN <https://jaymoulin.me/me/docker-jdownloader> <https://twitter.com/MoulinJay>"
LABEL version="${VERSION}-${ARCH}"

COPY ./${ARCH}/*.jar /opt/JDownloader/libs/
ENV XDG_DOWNLOAD_DIR=/opt/JDownloader/Downloads

# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
RUN mkdir -p /opt/JDownloader/ && \
    apt-get update && \
    apt-get install openjdk-8-jre ffmpeg wget -y && \
    wget -O /opt/JDownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && \
    chmod +x /opt/JDownloader/JDownloader.jar && \
    chmod 777 /opt/JDownloader/ -R && \
    apt-get autoremove -y && \
    rm /usr/bin/qemu-*-static

COPY daemon.sh /opt/JDownloader/
COPY default-config.json.dist /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
COPY configure.sh /usr/bin/configure

EXPOSE 3129
WORKDIR /opt/JDownloader

CMD ["/opt/JDownloader/daemon.sh"]
