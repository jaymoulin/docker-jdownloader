#!/bin/bash

wget -O ./JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && chmod +x ./JDownloader.jar
wget -O ./tini "https://github.com/krallin/tini/releases/download/v0.14.0/tini-static-armhf" && chmod +x tini

docker build -t jaymoulin/rpi-jdownloader .
