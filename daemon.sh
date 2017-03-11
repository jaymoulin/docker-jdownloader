#!/usr/bin/env bash

trap 'kill -TERM $PID' TERM INT
rm /opt/JDownloader/JDownloader.jar.*
rm /opt/JDownloader/JDownloader.pid
java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar &
PID=$!
wait $PID
wait $PID
EXIT_STATUS=$?
