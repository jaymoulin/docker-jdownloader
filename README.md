Raspberry PI - JDownloader - Docker Container
=

This container allows you to have JDownloader daemon installed easily thanks to Docker.

Installation
---

### With Docker Compose

First, configure your environment
```
cp docker-compose.yml.dist docker-compose.yml
```

A MyJDownloader Account is required so, if you don't already have one, you can register here for free : https://my.jdownloader.org/login.html#register

Then, install with:

```
docker-compose cloudprint -d
```

### With Docker

```
docker run -d --restart=always -v ~/Downloads:/root/Downloads --name jdownloader jaymoulin/rpi-jdownloader
```

You can replace `~/Downloads` with the folder you want your downloaded files to go.

Configuration
---

You must configure your MyJDownloader login/password with this command :

```
docker exec jdownloader configure credentials email@email.com password
```

Everything else can be configurable on your MyJDownloader account : https://my.jdownloader.org/index.html#dashboard

Appendixes
---

### Install RaspberryPi Docker

If you don't have Docker installed yet, you can do it easily in one line using this command
 
```
curl -sSL "https://gist.githubusercontent.com/jaymoulin/e749a189511cd965f45919f2f99e45f3/raw/054ba73080c49a0fcdbc6932e27887a31c7abce2/ARM%2520(Raspberry%2520PI)%2520Docker%2520Install" | sudo sh && sudo usermod -aG docker $USER
```

### Build Docker Image

To build this image locally 
```
docker build -t jaymoulin/rpi-jdownloader .
```
