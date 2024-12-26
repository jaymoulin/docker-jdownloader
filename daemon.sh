#!/bin/sh

trap 'kill -TERM $PID' TERM INT
rm -f /opt/JDownloader/app/JDownloader.jar.* 2> /dev/null
rm -f /opt/JDownloader/app/JDownloader.pid 2> /dev/null

# Define PUID/GID workaround for closed systems
if [ -n "$PUID" ]; then
    adduser jdown -D 2> /dev/null || useradd jdown 2> /dev/null
    usermod -u $PUID jdown
fi

if [ -n "$GID" ]; then
    groupmod -g $GID jdown
fi

# Login user with docker secret or env credentials - Please prefer command way
if [ -n "$FILE_MYJD_USER" ] && [ -n "$FILE_MYJD_PASSWORD" ]; then
    configure $(cat "/run/secrets/$FILE_MYJD_USER") $(cat "/run/secrets/$FILE_MYJD_PASSWORD")
elif [ -n "$MYJD_USER" ] && [ -n "$MYJD_PASSWORD" ]; then
    configure "$MYJD_USER" "$MYJD_PASSWORD"
fi

# Defining device name to jdownloader interface - please prefer this method than changing on MyJDownloader to keep correct binding
if [ -n "$MYJD_DEVICE_NAME" ]; then
    sed -Ei "s/\"devicename\":\"[^\"]*\"/\"devicename\":\"$MYJD_DEVICE_NAME\"/" /opt/JDownloader/app/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json
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
    rm /opt/JDownloader/app/Core.jar 2> /dev/null
    cp /opt/JDownloader/JDownloader.jar /opt/JDownloader/app/
fi

# Check JDownloader.jar integrity and removes it in case it's not
jar tvf /opt/JDownloader/app/JDownloader.jar > /dev/null 2>&1
if [ $? -ne 0 ]; then
    rm /opt/JDownloader/app/JDownloader.jar 2> /dev/null
    rm /opt/JDownloader/app/Core.jar > /dev/null
fi

# Check if JDownloader.jar exists, or if there is an interrupted update
if [ ! -f /opt/JDownloader/app/JDownloader.jar ] && [ -f /opt/JDownloader/app/tmp/update/self/JDU/JDownloader.jar ]; then
    rm /opt/JDownloader/app/Core.jar 2> /dev/null
    cp /opt/JDownloader/app/tmp/update/self/JDU/JDownloader.jar /opt/JDownloader/app/
fi

# Defines umask - should respect octal format
if echo "$UMASK" | grep -Eq '0[0-7]{3}' ; then
    echo "Defining umask to $UMASK"
    umask "$UMASK"
fi

if [ -n "$PUID" ]; then
    su jdown2 -c '${JAVA_HOME}/bin/java -Dsun.jnu.encoding=UTF-8 -Dfile.encoding=UTF-8 -Djava.awt.headless=true -jar /opt/JDownloader/app/JDownloader.jar -norestart' &
else
    java -Dsun.jnu.encoding=UTF-8 -Dfile.encoding=UTF-8 -Djava.awt.headless=true -jar /opt/JDownloader/app/JDownloader.jar -norestart &
fi
PID=$!
while [ "$PID" ]
do
    wait $PID
    PID=`pgrep java`
done
EXIT_STATUS=$?
