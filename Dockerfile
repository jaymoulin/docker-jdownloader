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

# Copy configure script
COPY ./scripts/configure.sh /usr/bin/configure

# Non privileged user
USER jdownloader

# Here happens the magic :-)
RUN mkdir -p /opt/JDownloader/ && \
    wget -O /opt/JDownloader/JDownloader.jar --user-agent="Travis CI Docker Image Build (https://github.com/tuxpeople)" "http://installer.jdownloader.org/JDownloader.jar " && \
    chmod +x /opt/JDownloader/JDownloader.jar && \
    chmod -R 755 /opt/JDownloader/

# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
COPY ./ressources/${ARCH}/*.jar /opt/JDownloader/libs/
COPY ./scripts/entrypoint.sh /opt/JDownloader/
COPY ./config/default-config.json.dist /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist

EXPOSE 3129
WORKDIR /opt/JDownloader

RUN ls -latr /opt/JDownloader/

VOLUME /opt/JDownloader

CMD ["/opt/JDownloader/entrypoint.sh"]