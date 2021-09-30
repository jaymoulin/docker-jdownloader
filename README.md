# jdownloader-headless
![Github Workflow Badge](https://github.com/tuxpeople/docker-jdownloader-headless/actions/workflows/release.yml/badge.svg)
![Github Last Commit Badge](https://img.shields.io/github/last-commit/tuxpeople/docker-jdownloader-headless)
![Docker Pull Badge](https://img.shields.io/docker/pulls/tdeutsch/jdownloader-headless)
![Docker Stars Badge](https://img.shields.io/docker/stars/tdeutsch/jdownloader-headless)
![Docker Size Badge](https://img.shields.io/docker/image-size/tdeutsch/jdownloader-headless)

    Caution: No more quay.io!
## Quick reference

Originally made by Jay Moulin. I made some improvements to it as it didn't work for me in Kubernetes.

This image allows you to have JDownloader 2 easily installed and controlled via [MyJDownloader](https://my.jdownloader.org/), thanks to Docker. No cluncky and rusty VNC sessions here!

* **Original Repository**
  https://github.com/jaymoulin/docker-jdownloader
* **Code repository:**
  https://github.com/tuxpeople/docker-jdownloader-headless
* **Where to file issues:**
  https://github.com/tuxpeople/docker-jdownloader-headless/issues
* **Supported architectures:**
  ```amd64```, ```armv7```, ```i386``` and ```arm64```

## Image tags
- ```latest``` gets automatically built on every push to master and also via a weekly cron job

## Usage
Installation
---

Here are some examples to get started with the creation of this container.

### Docker
```
docker run -d --init --restart=always -v </path/to/downloads>:/opt/JDownloader/Downloads -v </path/to/appdata/config>:/opt/JDownloader/cfg --name jdownloader -u $(id -u) -p 3129:3129 -e MYJD_USER=email@email.com -e MYJD_PASSWORD=bar -e MYJD_DEVICE_NAME=goofy tdeutsch/jdownloader-headless
```
### Docker Compose
```yml
services:
   jdownloader:
    image: tdeutsch/jdownloader-headless
    container_name: jdownloader
    restart: always
    user: 1001:100
    volumes:
        - </path/to/appdata/config>:/opt/JDownloader/cfg
        - </path/to/downloads>:/opt/JDownloader/Downloads
        - </path/to/appdata/logs>:/opt/JDownloader/logs #optional
        - /etc/localtime:/etc/localtime:ro #optional
    environment: 
            MYJD_USER: email@email.com #optional (see [Identify](https://github.com/tuxpeople/docker-jdownloader-headless#identify))
            MYJD_PASSWORD: bar #optional (see [Identify](https://github.com/tuxpeople/docker-jdownloader-headless#identify))
            MYJD_DEVICE_NAME: goofy #optional
            XDG_DOWNLOAD_DIR: /opt/JDownloader/Downloads #optional
    ports:
        - 3129:3129 
```

*Note for RPI Zero* : specify that you want the arm32v6 image (e.g. tdeutsch/jdownloader-headless:0.7.0-arm32v6) because rpi zero identify itself as armhf which is wrong.

Configuration
---
You can set many parameters when you configure this container, but you must specify your MyJDownloader login/password to connect to your container.

### Configuration values 
| Parameter | Function |
| :----: | --- |
| `-v /opt/JDownloader/cfg`| Config file folder, saves your configuration on the host |
| `-v /opt/JDownloader/logs` | Container logs folder, specify it only if you wan to keep logs on the host |
| `-v /opt/JDownloader/Downloads` | Downloads folder (where you put your `download` mountpoint) | 
| `-u <UID>:<GID>` | Add user identifiers to run the container with user priviledges. To obtain such values, run on your host `id yourusername`, additional information can be found in [Docker documentation](https://docs.docker.com/engine/reference/commandline/exec/#options)
| `-p 3129:3129` | This Network port is required for Direct Connection mode, more information in [this section](https://github.com/tuxpeople/docker-jdownloader-headless#direct-connection) |

### Environment Variables
| Parameter | Function |
| :----: | --- |
| `MYJD_USER=email@email.com` | Your MyJDownloader user |
| `MYJD_PASSWORD=foo` | Your MyJDownloader password |
| `MYJD_DEVICE_NAME=goofy`| The device name that will appear on MyJdownloader portal |
| `XDG_DOWNLOAD_DIR=/opt/JDownloader/Downloads` | If you use this variable, set it as per the downloads folder volume! |
| `UMASK="0002"` | Defines specific rights for your downloaded files (default: undefined) - Must respect octal form (begins with 0 followed by three numbers between 0 and 7 included) (cf. https://en.wikipedia.org/wiki/Umask) |

#### Identify
If haven't set MYJD_USER and MYJD_PASSWORD values, you can still configure an account by running (Recommended method)

```
docker exec jdownloader configure email@email.com password
```

Other options can be changed on your MyJDownloader account : https://my.jdownloader.org/index.html#dashboard.

Appendixes
---

### Direct Connection Mode

Direct Connection mode (or Direct Connections) improves the use of this container via MyJDownloader GUI and is strongly recommended at least in your LAN.

By enabling this mode, the communication happens directly between the client and the JDownloader server via port 3129 (by default), instead of being routed trough MyJDownloader servers. This enables the GUI to respond much faster with information reliably updating over time.
In this mode, MyJDownloader server still handles service related tasks, like the session authentication and notifications.

To enable Direct Connection mode from internet, you need to open and forward port 3129 adjusting your router configuration. Please find more information in this [JDownloader's article](https://support.jdownloader.org/Knowledgebase/Article/View/33/0/myjdownloader-advanced-settings)

#### DNS Rebind Warning
If you are running a router like Fritz!Box, Asus, OpenWRT, DDWRT, pfSense or any other 3rd party *advanced* routers you may have DNS Rebind Protection enabled: Direct Connections will not work, you will have to explicitly whitelist `mydns.jdownloader.org`. The procedure is different for every router, here are some tips:

* Fritz!Box: [KB Article](https://support.jdownloader.org/Knowledgebase/Article/View/51) from JDownloader
* Asus Merlin: Follow [this procedure](https://github.com/RMerl/asuswrt-merlin.ng/wiki/Custom-domains-with-dnsmasq) to enable custom scripts and edit the dnsmasq file, then add the line `rebind-domain-ok=/mydns.jdownloader.org/`
* OpenWRT: browse to Network>DHCP and DNS>General Settings and add `mydns.jdownloader.org` to Domain Whitelist
* pfSense: more information [here](https://github.com/jaymoulin/docker-jdownloader/issues/61#issuecomment-607474205)



### Direct Connection using a Bridged Network

To get Direct Connection when using a bridged newtwork, please follow these steps:

* Expose 3129 port when creating the container (`-p 3129:3129` parameter)
* When JDownloader is running, navigate to Settings > Advanced Settings > Search for "myjdownloader" > Find *MyJDownloaderSettings: Custom Device IPs* and enter your host LAN IP using this formatting `["192.168.1.10"]`. If you need to specify more IPs use `["192.168.1.10","10.10.10.10"]`
* Set *MyJDownloaderSettings: Manual Local Port* to `3129`
* Set *MyJDownloaderSettings: Direct Connect Mode* to `Allow lan/wan connections with manual port forwarding`
* Restart JDownloader, connections will now be direct

### Debugging

You can put a file called `jdownloader-block.txt` file in your Download folder to pause the container start.
This will allow to connect to the container with a shell to debug. (`docker exec -it jdownloader sh`) 