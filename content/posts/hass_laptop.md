---
author: "goosst"
date: 2019-11-02
title: Heating automation - laptop
tags:
 - crunchbang plus plus
 - debian
 - ebusd
 - ebus
 - home assistant
 - laptop
---

{{% toc %}}

# Intro
My singleboard computers (Raspberry 3b, tinkerboard) in combination with the ebus adapter didn't turn out to be very reliable. I was not able to pinpoint the exact root cause (most likely some power/voltage related issues). But on my laptop everything seems to work quite stable... .

This page is mainly to document the steps starting from a fresh linux install and setting up homeassistant and ebusd.
It starts with a fresh install of the debian based [crunchbangplusplus](https://www.crunchbangplusplus.org/), here installed on an (old) laptop with i386 processor.
Quite some additional python and other packages are specific for my installation, they can be left out to suit your needs.



# Install home assistant

This one mainly follows the steps outlined on the home assistant website to install hass in a virtual environment.

First prepare the list of repositories in crunchbangplusplus:
Add a line to your /etc/apt/sources.list: `deb http://ftp.de.debian.org/debian buster main`

```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev
sudo useradd -rm homeassistant
cd /srv
sudo mkdir homeassistant
sudo chown homeassistant:homeassistant homeassistant
sudo -u homeassistant -H -s
cd /srv/homeassistant
python3 -m venv .
source bin/activate
python3 -m pip install wheel
```

Install the development version of home assistant (or the stable of course):
```
exit
sudo -u homeassistant -H -s
source /srv/homeassistant/bin/activate
pip3 install --pre --upgrade homeassistant
exit
```
Due to some specific installation issues with the 0.100 version, this one had to be installed manually: `https://pypi.org/project/home-assistant-frontend/`

additional python packages

```
sudo apt-get install libfreetype6-dev pkg-config libjpeg-dev imagemagick mosquitto mosquitto-clients
sudo -u homeassistant -H -s
source /srv/homeassistant/bin/activate
pip3 install ilock requests datetime numpy pytz matplotlib pillow pyunsplash
exit
```

# Install ebusd

```
 wget -O - https://raw.githubusercontent.com/john30/ebusd-debian/master/ebusd.gpg.key|sudo apt-key add -
 dpkg --print-architecture
 sudo wget -O /etc/apt/sources.list.d/ebusd.list https://raw.githubusercontent.com/john30/ebusd-debian/master/ebusd-i386-nomqtt.list
 ```

 check status and let it start at boot
 ```
 sudo systemctl status ebusd
 sudo systemctl start ebusd
 sudo systemctl stop ebusd
 ```
start at bootup:
 ```
  sudo systemctl enable ebusd
```

# Launch homeassistant

Launch home assistant:
```
sudo -u homeassistant -H -s
source /srv/homeassistant/bin/activate
hass
```
Check if any error messages pop up in the command window. If so, try to resolve them.
surf to your ip address

## Folder settings

Exit from the virtual environment to set some folder settings.
I copy my yaml and python files through FileZilla, which requires to change the read/write settings.
Maybe there are other solutions, but I don't know them.

```
sudo mkdir /home/homeassistant/.homeassistant/www
sudo chmod -R 777 /home/homeassistant/.homeassistant/
```
copy files with Filezilla in the .homeassistant folder

run again `sudo chmod -R 777 /home/homeassistant/.homeassistant/`

# Static IP address

Let the laptop bootup with a fixed ip address:
run `sudo nmtui`, change the following (to have a fixed address: 192.168.0.205)
{{< figure src="/goosst/pictures/nmtui.png" title="network settings" width="550">}}


# Result
{{< figure src="/goosst/pictures/hass_ui.png" title="hass interface" width="750">}}
