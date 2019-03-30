![logo](logo.png "logo")

JDownloader - Docker Image
==========================

[![latest release](https://img.shields.io/github/release/jaymoulin/docker-jdownloader.svg "latest release")](http://github.com/jaymoulin/docker-jdownloader/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/jaymoulin/jdownloader.svg)](https://hub.docker.com/r/jaymoulin/jdownloader/)
[![Docker stars](https://img.shields.io/docker/stars/jaymoulin/jdownloader.svg)](https://hub.docker.com/r/jaymoulin/jdownloader/)
[![Docker Pulls](https://img.shields.io/docker/pulls/jaymoulin/rpi-jdownloader.svg)](https://hub.docker.com/r/jaymoulin/rpi-jdownloader/)
[![Docker stars](https://img.shields.io/docker/stars/jaymoulin/rpi-jdownloader.svg)](https://hub.docker.com/r/jaymoulin/rpi-jdownloader/)
[![Bitcoin donation](https://github.com/jaymoulin/jaymoulin.github.io/raw/master/btc.png "Bitcoin donation")](https://m.freewallet.org/id/374ad82e/btc)
[![Litecoin donation](https://github.com/jaymoulin/jaymoulin.github.io/raw/master/ltc.png "Litecoin donation")](https://m.freewallet.org/id/374ad82e/ltc)
[![PayPal donation](https://github.com/jaymoulin/jaymoulin.github.io/raw/master/ppl.png "PayPal donation")](https://www.paypal.me/jaymoulin)
[![Buy me a coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png "Buy me a coffee")](https://www.buymeacoffee.com/3Yu8ajd7W)


This image allows you to have JDownloader daemon installed easily thanks to Docker.

Installation
---

```
docker run -d --restart=always -v ~/Downloads:/root/Downloads -v ~/jdownloader/cfg:/opt/JDownloader/cfg --name jdownloader -u $(id -u):$(id -g) jaymoulin/jdownloader
```

You can replace `~/Downloads` with the folder you want your downloaded files to go.

It is recommended to add `-v ~/jdownloader/cfg:/opt/JDownloader/cfg` to your command to save all your configurations.
Note: Use the `-u $(id -u):$(id -g)` part for jdownloader to run as a specific user. It's recommanded to use static values (see: https://docs.docker.com/engine/reference/commandline/exec/#options)

*Note for RPI Zero* : specify that you want the arm32v6 image (e.g. jaymoulin/jdownloader:0.7.0-arm32v6) because rpi zero identify itself as armhf which is wrong.

Configuration
---

You must configure your MyJDownloader login/password with this command :

```
docker exec jdownloader configure email@email.com password
```

Everything else can be configurable on your MyJDownloader account : https://my.jdownloader.org/index.html#dashboard

Appendixes
---

### Install Docker

If you don't have Docker installed yet, you can do it easily in one line using this command
 
```
curl -sSL "https://gist.githubusercontent.com/jaymoulin/e749a189511cd965f45919f2f99e45f3/raw/0e650b38fde684c4ac534b254099d6d5543375f1/ARM%2520(Raspberry%2520PI)%2520Docker%2520Install" | sudo sh && sudo usermod -aG docker $USER
```
