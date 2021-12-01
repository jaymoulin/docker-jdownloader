#!/bin/sh

trap 'kill -TERM $PID' TERM INT
rm -f /opt/JDownloader/app/JDownloader.jar.*
rm -f /opt/JDownloader/app/JDownloader.pid

# Login user with env credentials - Please prefer command way
if [ -n "$MYJD_USER" ] && [ -n "$MYJD_PASSWORD" ]; then
    configure "$MYJD_USER" "$MYJD_PASSWORD"
fi

# Defining device name to jdownloader interface - please prefer this method than changing on MyJDownloader to keep correct binding
if [ -n "$MYJD_DEVICE_NAME" ]; then
    sed -Ei "s/\"devicename\" : .+\"(,?)/\"devicename\" : \"$MYJD_DEVICE_NAME\"\1/" /opt/JDownloader/app/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json
fi

# Debugging helper - if the container crashes, create a file called "jdownloader-block.txt" in the download folder
# The container will not terminate (and you can run "docker exec -it ... bash")
if [ -f /opt/JDownloader/Downloads/jdownloader-block.txt ]; then
    sleep 1000000
fi

# Copy libs if not copied yet
if [ ! -f /opt/JDownloader/app/libs/sevenzipjbinding1509.jar ]; then
    cp /opt/JDownloader/libs/*.jar /opt/JDownloader/app/libs/
fi

# Copy if no JDownloader exists
if [ ! -f /opt/JDownloader/app/JDownloader.jar ]; then
    cp /opt/JDownloader/JDownloader.jar /opt/JDownloader/app/
fi

# Check JDownloader.jar integrity and removes it in case it's not
jar tvf /opt/JDownloader/app/JDownloader.jar > /dev/null 2>&1
if [ $? -ne 0 ]; then
    rm /opt/JDownloader/app/JDownloader.jar
fi

# Check if JDownloader.jar exists, or if there is an interrupted update
if [ ! -f /opt/JDownloader/app/JDownloader.jar ] && [ -f /opt/JDownloader/app/tmp/update/self/JDU/JDownloader.jar ]; then
    cp /opt/JDownloader/app/tmp/update/self/JDU/JDownloader.jar /opt/JDownloader/app/
fi

# Defines umask - should respect octal format
if echo "$UMASK" | grep -Eq '0[0-7]{3}' ; then
    echo "Defining umask to $UMASK"
    umask "$UMASK"
fi

java -Dsun.jnu.encoding=UTF-8 -Dfile.encoding=UTF-8 -Djava.awt.headless=true -jar /opt/JDownloader/app/JDownloader.jar -norestart &
PID=$!
wait $PID
wait $PID

EXIT_STATUS=$?
