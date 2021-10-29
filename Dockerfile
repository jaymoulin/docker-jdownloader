FROM alpine:3.14.2

# set args
ARG BUILD_DATE
ARG VERSION
ARG TARGETARCH
ARG TARGETPLATFORM
ARG NAME

# set env
ENV LD_LIBRARY_PATH=/lib;/lib32;/usr/lib
ENV XDG_DOWNLOAD_DIR=/opt/JDownloader/Downloads
ENV UMASK=''
ENV LC_CTYPE="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV LC_COLLATE="C"
ENV LANGUAGE="C.UTF-8"
ENV LC_ALL="C.UTF-8"

# ARG TARGETPLATFORM
# ARG BUILDPLATFORM
# ARG TARGETOS
# ARG TARGETARCH
# ARG TARGETVARIANT
# RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"
# RUN echo "$TARGETPLATFORM consists of $TARGETOS, $TARGETARCH and $TARGETVARIANT"

# Upgrade and install dependencies
# hadolint ignore=DL3018,DL3019
RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache --upgrade openjdk8-jre ca-certificates libstdc++ ffmpeg wget jq moreutils@community tini && \
    mkdir -p /init && \
    mkdir -p /opt/JDownloader && \
    wget -q -O /init/JDownloader.jar --user-agent="Github Docker Image Build (https://github.com/tuxpeople)" "http://installer.jdownloader.org/JDownloader.jar" && \
    chmod +x /init/JDownloader.jar && \
    chmod -R 777 /opt/JDownloader* /init

# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
COPY ./ressources/${TARGETARCH}/*.jar /init/libs/
COPY ./scripts/entrypoint.sh /
COPY ./config/default-config.json.dist /init/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
COPY ./scripts/configure.sh /usr/bin/configure

EXPOSE 3129
WORKDIR /opt/JDownloader
VOLUME /opt/JDownloader

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/entrypoint.sh"]
