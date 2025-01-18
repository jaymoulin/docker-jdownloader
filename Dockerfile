FROM bellsoft/liberica-openjdk-alpine:10.0.2-x86_64 AS base-amd64-v1
FROM bellsoft/liberica-openjdk-alpine:10.0.2-armv7l AS base-arm-v7

FROM bellsoft/liberica-openjdk-debian:11.0.25-aarch64 AS base-arm64-v1
ENV ISDEB=1
FROM balenalib/raspberry-pi AS base-arm-v6
ENV ISDEB=1

FROM base-${TARGETARCH}-${TARGETVARIANT:-v1}

ARG VERSION="2.2.0"
ARG TARGETPLATFORM
LABEL maintainer="Jay MOULIN <https://brands.jaymoulin.me/me/docker-jdownloader>"
LABEL version="${VERSION}-${TARGETPLATFORM}"
ENV LD_LIBRARY_PATH=/lib;/lib32;/usr/lib
ENV XDG_DOWNLOAD_DIR=/opt/JDownloader/Downloads
ENV LC_CTYPE="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV LC_COLLATE="C"
ENV LANGUAGE="C.UTF-8"
ENV LC_ALL="C.UTF-8"
ENV UMASK=''
COPY ./${TARGETPLATFORM}/*.jar /opt/JDownloader/libs/
# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
RUN mkdir -p /opt/JDownloader/app/libs

COPY daemon.sh /opt/JDownloader/
COPY default-config.json.dist /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
COPY configure.sh /usr/bin/configure

EXPOSE 3129
WORKDIR /opt/JDownloader

CMD ["/opt/JDownloader/daemon.sh"]

RUN if [ "" = "$ISDEB" ]; then apk add --update libstdc++ ffmpeg wget procps shadow fontconfig ttf-dejavu && \
     wget -O /opt/JDownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && \
     chmod 777 /opt/JDownloader/ -R && \
     apk del wget --purge; \
    else apt-get update && \
     apt-get install ffmpeg wget procps fontconfig fonts-dejavu -y && \
     (java -version || apt-get install openjdk-8-jdk) && \
     wget -O /opt/JDownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && \
     chmod 777 /opt/JDownloader/ -R && \
     apt-get autoremove -y wget; fi
