FROM balenalib/raspberry-pi as builder

COPY qemu-arm-static /usr/bin/

FROM builder

ARG ARCH=armel
ARG VERSION="0.7.1"
LABEL maintainer="Jay MOULIN <jaymoulin@gmail.com> <https://twitter.com/MoulinJay>"
LABEL version="${VERSION}-${ARCH}"

COPY ./${ARCH}/*.jar /opt/JDownloader/libs/
# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
RUN mkdir -p /opt/JDownloader/ && \
    apt update && \
    apt install openjdk-8-jre ffmpeg wget -y && \
    wget -O /opt/JDownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && \
    chmod +x /opt/JDownloader/JDownloader.jar && \
    wget -O /usr/bin/tini-static "https://github.com/krallin/tini/releases/download/v0.18.0/tini-static-${ARCH}" --no-check-certificate && \
    chmod +x /usr/bin/tini-static && \
    chmod 777 /opt/JDownloader/ -R && \
    apt autoremove -y wget && \
    rm /usr/bin/qemu-*-static


COPY daemon.sh /opt/JDownloader/
COPY default-config.json.dist /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
COPY configure.sh /usr/bin/configure

WORKDIR /opt/JDownloader

CMD ["tini-static", "--", "/opt/JDownloader/daemon.sh"]
