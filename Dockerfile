FROM larmog/armhf-alpine-java

MAINTAINER Jay MOULIN <jaymoulin@gmail.com>

RUN mkdir /opt/JDownloader/ && \
    wget -O /opt/JDownloader/JDownloader.jar http://installer.jdownloader.org/JDownloader.jar && \
    java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar &&
    cp /opt/JDownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json /opt/JDownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist

ADD configure /usr/bin/configure
RUN chmod +x /usr/bin/configure

CMD ["java", "-Djava.awt.headless=true", "-jar", "/opt/JDownloader/JDownloader.jar"]