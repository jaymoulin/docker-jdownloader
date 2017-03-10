FROM larmog/armhf-alpine-java:jdk-8u73

MAINTAINER Jay MOULIN <jaymoulin@gmail.com>

RUN mkdir /opt/JDownloader/

ADD JDownloader.jar /opt/JDownloader/JDownloader.jar
ADD default-config.json.dist /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
ADD configure.sh /usr/bin/configure

VOLUME /root/Downloads
VOLUME /opt/JDownloader/cfg

CMD ["java", "-Djava.awt.headless=true", "-jar", "/opt/JDownloader/JDownloader.jar"]
