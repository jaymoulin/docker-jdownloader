FROM larmog/armhf-alpine-java:jdk-8u73

MAINTAINER Jay MOULIN <jaymoulin@gmail.com>

# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
RUN mkdir /opt/JDownloader/
RUN apk add --update libstdc++ && apk add wget  --virtual .build-deps && \
	wget -O /opt/JDownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && chmod +x /opt/JDownloader/JDownloader.jar && \
	apk del wget --purge .build-deps
ENV LD_LIBRARY_PATH=/lib;/lib32;/usr/lib


ADD daemon.sh /opt/JDownloader/
ADD default-config.json.dist /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
ADD configure.sh /usr/bin/configure

VOLUME /root/Downloads
VOLUME /opt/JDownloader/cfg
WORKDIR /opt/JDownloader

CMD ["/opt/JDownloader/daemon.sh"]
