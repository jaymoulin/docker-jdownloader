#!/bin/sh

usage="$(basename "$0") <email> <password>"

if [ ! $# -eq 2 ]; then
    echo "$usage"
    exit 1
fi
password=`echo $2 | sed 's/"/\\\\\\\\"/g'`
email=`echo $1 | sed 's/"/\\\\\\\\"/g'`

if [ ! -f /opt/JDownloader/app/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json ]; then
    cp /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist /opt/JDownloader/app/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json
fi

sed -Ei "s/\"password\":\"[^\"]*\"/\"password\":\"$password\"/" /opt/JDownloader/app/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json && \
sed -Ei "s/\"email\":\"[^\"]*\"/\"email\":\"$email\"/" /opt/JDownloader/app/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json
(pkill -f "JDownloader" || reboot)
