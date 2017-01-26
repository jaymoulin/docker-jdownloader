FROM larmog/armhf-alpine-java:jdk-8u73

MAINTAINER Jay MOULIN <jaymoulin@gmail.com>

RUN mkdir /opt/JDownloader/ && \
    wget -O /opt/JDownloader/JDownloader.jar http://installer.jdownloader.org/JDownloader.jar && \
    java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar  && \
    echo -e "{ \n\
  \"autoconnectenabledv2\" : true,\n\
  \"password\" : null,\n\
  \"email\" : null\n\
}" > /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist

ADD configure /usr/bin/configure
RUN chmod +x /usr/bin/configure

VOLUME /root/Downloads
VOLUME /opt/JDownloader/cfg

CMD ["java", "-Djava.awt.headless=true", "-jar", "/opt/JDownloader/JDownloader.jar"]
