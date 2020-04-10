---
author: "goosst"
date: 2019-11-02
title: Setup debian system
tags:
 - crunchbang plus plus
 - armbian
 - debian
 - ebusd
 - ebus
 - home assistant
 - laptop
---

{{% toc %}}

# Intro

This page is mainly to document the steps starting from a fresh linux install and setting up homeassistant and ebusd.

It starts with a fresh install of the debian based [crunchbangplusplus](https://www.crunchbangplusplus.org/), here installed on an (old) laptop with i386 processor.
The same method has worked on other debian based systems (tested on armbian running on a tinkerboard).
It is assumed the debian based distro is based on debian Buster.
Quite some additional python and other packages are specific for my installation, they can be left out to suit your needs.

# Remote access

To make life easy and not be close to your machine running home assistant:

* ssh into the remote machine
* `sudo apt-get install tmux`
* start tmux by typing tmux
* execute your commands in the started tmux session
* leave/detach the tmux session by typing Ctrl+b and then d
* If you connect again after being disconnected, type `tmux attach`

# Install home assistant

This one mainly follows the steps outlined on the home assistant website to install hass in a virtual environment.

First prepare the list of repositories in crunchbangplusplus:
Add a line to your /etc/apt/sources.list: `deb http://ftp.de.debian.org/debian buster main`

```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev build-essential
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
sudo apt-get install libfreetype6-dev pkg-config libjpeg-dev imagemagick mosquitto mosquitto-clients python3-scipy
sudo apt-get -y install liblapack-dev libblas-dev gfortran
sudo -u homeassistant -H -s
source /srv/homeassistant/bin/activate
pip3 install ilock requests datetime numpy pytz matplotlib pillow pyunsplash scipy
exit
```

# Install ebusd

select the correct computer-architecture:
```
 wget -O - https://raw.githubusercontent.com/john30/ebusd-debian/master/ebusd.gpg.key|sudo apt-key add -
 dpkg --print-architecture
 sudo wget -O /etc/apt/sources.list.d/ebusd.list https://raw.githubusercontent.com/john30/ebusd-debian/master/ebusd-i386-nomqtt.list
 ```

```
sudo apt-get update
sudo apt-get install ebusd
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
Brows to http://ip_address:8123, to see if you can access. Setup an account.

## Folder settings

Exit from the virtual environment to set some folder settings.
I copy my yaml and python files through FileZilla, which requires to change the read/write settings.
Maybe there are other solutions ... .

```
sudo mkdir /home/homeassistant/.homeassistant/www
sudo chmod -R 777 /home/homeassistant/.homeassistant/
```
Copy files with Filezilla in the .homeassistant folder.
Run again the chmod command on the directory and its subfolders
```
sudo chmod -R 777 /home/homeassistant/.homeassistant/
sudo chmod -R 777 /home/homeassistant/.homeassistant/python_scripts/
```

# Static IP address

Let the laptop bootup with a fixed ip address:
run `sudo nmtui`, change the following in `edit connection` (to have a fixed address: 192.168.0.205)
{{< figure src="/goosst/pictures/nmtui.png" title="network settings" width="550">}}

Most likely requires a reboot (and access to a display instead of ssh).


# Result
{{< figure src="/goosst/pictures/hass_ui.png" title="hass interface" width="750">}}
