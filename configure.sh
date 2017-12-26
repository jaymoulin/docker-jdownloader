#!/bin/sh

usage="$(basename "$0") <email> <password>"

if [ ! $# -eq 2 ]; then
    echo "$usage"
    exit 1
fi

if [ ! -f /opt/JDownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json ]; then
    cp /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist /opt/JDownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json
fi

sed -i "s/\"password\" : [^,]+/\"password\" : \"$2\"/" /opt/JDownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json && \
sed -i "s/\"email\" : [^,]+/\"email\" : \"$1\"/" /opt/JDownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json
pkill -f "JDownloader"
