#!/bin/sh

usage="$(basename "$0") <email> <password>"
SETTINGSFILE="/opt/JDownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json"

if [ ! $# -eq 2 ]; then
    echo "$usage"
    exit 1
fi

if [ ! -f ${SETTINGSFILE} ]; then
    cp /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist ${SETTINGSFILE}
fi

jq --arg v "${2}" '.password = $v' ${SETTINGSFILE} | sponge ${SETTINGSFILE}
jq --arg v "${1}" '.email = $v' ${SETTINGSFILE} | sponge ${SETTINGSFILE}

pkill -f "JDownloader"