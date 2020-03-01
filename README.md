![logo](logo.png "logo")

JDownloader 2 - Docker Image
==========================

[![latest release](https://img.shields.io/github/release/jaymoulin/docker-jdownloader.svg "latest release")](http://github.com/jaymoulin/docker-jdownloader/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/jaymoulin/jdownloader.svg)](https://hub.docker.com/r/jaymoulin/jdownloader/)
[![Docker stars](https://img.shields.io/docker/stars/jaymoulin/jdownloader.svg)](https://hub.docker.com/r/jaymoulin/jdownloader/)
[![PayPal donation](https://github.com/jaymoulin/jaymoulin.github.io/raw/master/ppl.png "PayPal donation")](https://www.paypal.me/jaymoulin)
[![Buy me a coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png "Buy me a coffee")](https://www.buymeacoffee.com/3Yu8ajd7W)
[![Become a Patron](https://badgen.net/badge/become/a%20patron/F96854 "Become a Patron")](https://patreon.com/jaymoulin)


This image allows you to have JDownloader 2 daemon installed easily thanks to Docker.

Installation
---

```
docker run -d --init --restart=always -v ~/Downloads:/opt/JDownloader/Downloads -v ~/jdownloader/cfg:/opt/JDownloader/cfg --name jdownloader -u $(id -u) -e MYJD_USER=email@email.com -e MYJD_PASSWORD=password jaymoulin/jdownloader
```

The environment variables are not mandatory.

You can replace `~/Downloads` with the folder you want your downloaded files to go.

It is recommended to add `-v ~/jdownloader/cfg:/opt/JDownloader/cfg` to your command to save all your configurations.
Note: Use the `-u $(id -u)` part for JDownloader to run as a specific user. It's recommended to use static values (see: https://docs.docker.com/engine/reference/commandline/exec/#options)
Note: Add `-p 3129:3129` to allow JDownloader direct connections (this has to be forwarded in your router) (see: https://support.jdownloader.org/Knowledgebase/Article/View/33/0/myjdownloader-advanced-settings)

*Note for RPI Zero* : specify that you want the arm32v6 image (e.g. jaymoulin/jdownloader:0.7.0-arm32v6) because rpi zero identify itself as armhf which is wrong.

Configuration
---

You must configure your MyJDownloader login/password using this environment variables:
```
MYJD_USER=email@email.com
MYJD_PASSWORD=password
```
or with this command :

```
docker exec jdownloader configure email@email.com password
```

Everything else can be configurable on your MyJDownloader account : https://my.jdownloader.org/index.html#dashboard.

Appendixes
---

### Direct Connection

As @jiaz83 stated

> short explanation what the direct connection mode does.
> client(app,webinterface,tool...)<-....->JDownloader connections happens either
> 
> 1.) client<-apiserver->JDownloader
> in this(default,fallback) mode both(control- and data-) connections are using the api server.
> Advantage: no need to forward ports/dyndns
> Disadvantage: lower bandwidth and higher latency
> 
> 2.) client<->JDownloader
> in this (direct connection) mode, control connections are still using the api server while data connections are directly connecting to the running JDownloader instance without any relay server
> Advantage: much higher bandwidth and reduced latency
> Disadvantage: user might have to manually enable/allow port forwarding from LAN and/or WAN IP to JDownloader instance
> On connection issues, the client will automatically fallback to 1.) and try to re-establish a direct connection again.
> 
> by default direct connection mode is set to LAN, so only clients from LAN can connect directly.
> see https://support.jdownloader.org/Knowledgebase/Article/View/33/0/myjdownloader-advanced-settings
> default port is 3129

### Direct Connection using a Bridged Network

To get Direct Connection when using a bridged newtwork, please follow these steps:

* Expose 3129 port when creating the container (`-p 3129:3129` parameter)
* When JDownloader is running, navigate to Settings > Advanced Settings > Search for "myjdownloader" > Find *MyJDownloaderSettings: Custom Device IPs* and enter your host LAN IP using this formatting `["192.168.1.10"]`. If you need to specify more IPs use `["192.168.1.10","10.10.10.10"]`
* Set *MyJDownloaderSettings: Manual Local Port* to `3129`
* Set *MyJDownloaderSettings: Direct Connect Mode* to `Allow lan/wan connections with manual port forwarding`
* Restart JDownloader, connections will now be direct

### Debugging

You can put a file called `jdownloader-block.txt` file in your Download folder to pose the container start.
This will allow to connect to the container with a shell to debug. (`docker exec -it jdownloader sh`) 

### Install Docker

If you don't have Docker installed yet, you can do it easily in one line using this command
 
```
curl -sSL "https://gist.githubusercontent.com/jaymoulin/e749a189511cd965f45919f2f99e45f3/raw/0e650b38fde684c4ac534b254099d6d5543375f1/ARM%2520(Raspberry%2520PI)%2520Docker%2520Install" | sudo sh && sudo usermod -aG docker $USER
```

### Docker compose

Here is an example of docker-compose file

```yml
version: "2"
services:
    jdownloader:
        image: jaymoulin/jdownloader
        ports:
            - 3129:3129
        volumes:
            - ~/Downloads:/opt/JDownloader/Downloads
        environment: 
            MYJD_USER: goofy
            MYJD_PASSWORD: foo
        restart: always
```
