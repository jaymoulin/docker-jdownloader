FROM openjdk:jre-alpine

# set args
ARG BUILD_DATE
ARG VERSION
ARG ARCH
ARG NAME

# set labels
LABEL maintainer="Thomas Deutsch <thomas@tuxpeople.org>"
LABEL build_version="${NAME} Version:- ${VERSION} Build-date:- ${BUILD_DATE} Arch:- ${ARCH}"

# set env
ENV LD_LIBRARY_PATH=/lib;/lib32;/usr/lib
ENV XDG_DOWNLOAD_DIR=/opt/JDownloader/Downloads
ENV UMASK=''

# Upgrade and install dependencies
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --update libstdc++ ffmpeg wget jq moreutils@testing

# Here happens the magic :-)
RUN mkdir -p /init && \
    mkdir -p /opt/JDownloader && \
    wget -O /init/JDownloader.jar --user-agent="Travis CI Docker Image Build (https://github.com/tuxpeople)" "http://installer.jdownloader.org/JDownloader.jar" && \
    chmod +x /init/JDownloader.jar && \
    chmod -R 777 /opt/JDownloader* /init

# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
COPY ./ressources/${ARCH}/*.jar /init/libs/
COPY ./scripts/entrypoint.sh /
COPY ./config/default-config.json.dist /init/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
COPY ./scripts/configure.sh /usr/bin/configure

EXPOSE 3129
WORKDIR /opt/JDownloader
VOLUME /opt/JDownloader

CMD ["/entrypoint.sh"]