#!/bin/sh

trap 'kill -TERM $PID' TERM INT
rm -f /opt/JDownloader/JDownloader.jar.*
rm -f /opt/JDownloader/JDownloader.pid

SETTINGSFILE="/opt/JDownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json"

# Login user with env credentials - Please prefer command way
if [ -n "$MYJD_USER" ] && [ -n "$MYJD_PASSWORD" ]; then
    configure "$MYJD_USER" "$MYJD_PASSWORD"
fi

# Defining device name to jdownloader interface - please prefer this method than changing on MyJDownloader to keep correct binding
if [ -n "$MYJD_DEVICE_NAME" ]; then
    jq --arg v "${MYJD_DEVICE_NAME}" '.devicename = $v' ${SETTINGSFILE} | sponge ${SETTINGSFILE}
fi

# Debugging helper - if the container crashes, create a file called "jdownloader-block.txt" in the download folder
# The container will not terminate (and you can run "docker exec -it ... bash")
if [ -f /opt/JDownloader/Downloads/jdownloader-block.txt ]; then
    sleep 1000000
fi

ls -latr /opt/JDownloader/

# Check if volume needs init
if [ ! -f /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist ]; then
    cp -r /init/* /opt/JDownloader/
fi

ls -latr /opt/JDownloader/

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
    wget -O /opt/JDownloader/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar"
    chmod +x /opt/JDownloader/JDownloader.jar
fi

# Defines umask - should respect octal format
if echo "$UMASK" | grep -Eq '0[0-7]{3}' ; then
    echo "Defining umask to $UMASK"
    umask "$UMASK"
fi

java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar -norestart &
PID=$!
wait $PID
wait $PID

EXIT_STATUS=$?
