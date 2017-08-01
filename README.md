![logo](logo.png "logo")

Raspberry PI - JDownloader - Docker Image
=

[![latest release](https://img.shields.io/github/release/jaymoulin/docker-rpi-jdownloader.svg "latest release")](http://github.com/jaymoulin/docker-rpi-jdownloader/releases)

This image allows you to have JDownloader daemon installed easily thanks to Docker.

Installation
---

```
docker run -d --restart=always -v ~/Downloads:/root/Downloads -v ~/jdownloader/cfg:/opt/JDownloader/cfg --name jdownloader jaymoulin/rpi-jdownloader
```

You can replace `~/Downloads` with the folder you want your downloaded files to go.

It is recommended to add `-v ~/jdownloader/cfg:/opt/JDownloader/cfg` to your command to save all your configurations. 

Configuration
---

You must configure your MyJDownloader login/password with this command :

```
docker exec jdownloader configure email@email.com password
```

Everything else can be configurable on your MyJDownloader account : https://my.jdownloader.org/index.html#dashboard

Appendixes
---

### Install RaspberryPi Docker

If you don't have Docker installed yet, you can do it easily in one line using this command
 
```
curl -sSL "https://gist.githubusercontent.com/jaymoulin/e749a189511cd965f45919f2f99e45f3/raw/054ba73080c49a0fcdbc6932e27887a31c7abce2/ARM%2520(Raspberry%2520PI)%2520Docker%2520Install" | sudo sh && sudo usermod -aG docker $USER
```
