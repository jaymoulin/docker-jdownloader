FROM larmog/armhf-alpine-java:jdk-8u73

MAINTAINER Jay MOULIN <jaymoulin@gmail.com>

# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
RUN mkdir /opt/JDownloader/
RUN apk update && \
	apk add --update libstdc++ && apk add wget  --virtual .build-deps && \
	wget -O /opt/JDownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && chmod +x /opt/JDownloader/JDownloader.jar && \
	wget -O /sbin/tini "https://github.com/krallin/tini/releases/download/v0.16.1/tini-static-armhf" --no-check-certificate && chmod +x /sbin/tini && \
	apk del wget --purge .build-deps && \
	apk add ffmpeg
ENV LD_LIBRARY_PATH=/lib;/lib32;/usr/lib


ADD daemon.sh /opt/JDownloader/
ADD default-config.json.dist /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
ADD configure.sh /usr/bin/configure

VOLUME /root/Downloads
VOLUME /opt/JDownloader/cfg
WORKDIR /opt/JDownloader

CMD ["/sbin/tini", "--", "/opt/JDownloader/daemon.sh"]
