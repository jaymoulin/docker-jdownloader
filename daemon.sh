#!/bin/sh

trap 'kill -TERM $PID' TERM INT
rm -f /opt/JDownloader/JDownloader.jar.*
rm -f /opt/JDownloader/JDownloader.pid

if [ ! -z "$MYJD_USER" ] && [ ! -z "$MYJD_PASSWORD" ]; then
    configure "$MYJD_USER" "$MYJD_PASSWORD"
fi

# Debugging helper - if the container crashes, create a file called "jdownloader-block.txt" in the download folder
# The container will not terminate (and you can run "docker exec -it ... bash")
if [ -f /opt/JDownloader/Downloads/jdownloader-block.txt ]; then
    sleep 1000000
fi

# Check JDownloader.jar integrity and removes it in case it's not
jar tvf /opt/JDownloader/JDownloader.jar > /dev/null 2>&1
if [ $? -ne 0 ]; then
    rm /opt/JDownloader/JDownloader.jar
fi

# Check if JDownloader.jar exists, or if there is an interrupted update
if [ ! -f /opt/JDownloader/JDownloader.jar ] && [ -f /opt/JDownloader/tmp/update/self/JDU/JDownloader.jar ]; then
    cp /opt/JDownloader/tmp/update/self/JDU/JDownloader.jar /opt/JDownloader/
fi

# Redownload if no JDownloader exists
if [ ! -f /opt/JDownloader/JDownloader.jar ]; then
    wget -O /opt/JDownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM"
    chmod +x /opt/JDownloader/JDownloader.jar
fi

java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar &
PID=$!
wait $PID
wait $PID

EXIT_STATUS=$?
