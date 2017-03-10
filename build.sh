#!/bin/bash

wget -O ./JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && chmod +x ./JDownloader.jar

docker build -t jaymoulin/rpi-jdownloader .