FROM larmog/armhf-alpine-java:jdk-8u73

MAINTAINER Jay MOULIN <jaymoulin@gmail.com>

# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
RUN apk add --update libstdc++
ENV LD_LIBRARY_PATH=/lib;/lib32;/usr/lib

RUN mkdir /opt/JDownloader/

ADD JDownloader.jar /opt/JDownloader/JDownloader.jar
ADD daemon.sh /opt/JDownloader/
ADD default-config.json.dist /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
ADD configure.sh /usr/bin/configure

VOLUME /root/Downloads
VOLUME /opt/JDownloader/cfg
WORKDIR /opt/JDownloader

CMD ["/opt/JDownloader/daemon.sh"]