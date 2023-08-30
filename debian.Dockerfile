FROM openjdk:jre-alpine as builder

COPY qemu-arm-static /usr/bin/
COPY qemu-aarch64-static /usr/bin/

FROM builder

ARG ARCH=armel
ARG VERSION="2.1.1"
LABEL maintainer="Jay MOULIN <https://brands.jaymoulin.me/me/docker-jdownloader>"
LABEL version="${VERSION}-${ARCH}"

COPY ./${ARCH}/*.jar /opt/JDownloader/libs/
ENV XDG_DOWNLOAD_DIR=/opt/JDownloader/Downloads

# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
RUN mkdir -p /opt/JDownloader/app/ && \
    apt-get update && \
    apt-get install ffmpeg wget procps -y && \
    (java -version || apt-get install openjdk-8-jre) && \
    wget -O /opt/JDownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && \
    chmod 777 /opt/JDownloader/ -R && \
    apt-get autoremove -y wget && \
    rm /usr/bin/qemu-*-static

COPY daemon.sh /opt/JDownloader/
COPY default-config.json.dist /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
COPY configure.sh /usr/bin/configure

EXPOSE 3129
WORKDIR /opt/JDownloader

CMD ["/opt/JDownloader/daemon.sh"]
