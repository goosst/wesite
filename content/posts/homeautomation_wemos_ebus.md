---
author: "goosst"
date: 2019-12-21
title: Heating automation - setup hardware and ebus
tags:
 - vaillant
 - ecotec plus
 - ebus
 - home assistant
 - Ebusd
 - wemos mini D1
---

{{% toc %}}

# Intro
In this part we'll connect to the communication bus of the heater and read / write some parameters by manually commanding them via a raspberry pi (in general, the instructions below work with any computer using debian/ubuntu).


# Hardware

## Ebus adapter
We need an ebus adapter for the raspberry to interface with our heater. I'm not going to write down all the details, since I can just refer to them:

* Start reading here for more background: https://ebus.github.io/adapter/index.en.html
* I'm using the base board version 2.2, there might be better options to use directly with a raspberry pi. But when I ordered, it looked like the most flexible solution.
* Adapter was ordered on the fhem forum. They will send you a pcb with a set of components, you have to solder yourself (or pay a bit extra): https://forum.fhem.de/index.php/topic,93190.msg857894.html#msg857894. If you've read the first link you will also know there are commercial options in case you don't want this.
* Put it in a box so there is no chance on touching electrical connections etc. .
 * You could consider placing the adapter inside the heater (plenty of space), I just didn't want to put custom electronics inside ... .

{{< figure src="/goosst/pictures/ebus_adapter.jpg" title="ebus adapter v2.2" width="250">}}

## Attention!!

***Connecting the ebus adapter over USB to your host, is not reliable over longer periods of time! I've wasted way too much time with an unreliable home automation because of this. Connecting the adapter to a wemos, seems the more reliable route.***

If you're running on a single board computer:

* Please use a decent [power supply with at least 2/3A](https://www.banggood.com/DC-5V-3_0A-EU-Power-Supply-Micro-USB-Adapter-Charger-For-Raspberry-Pi-3-Model-B-p-1079928.html?p=ET150713234951201708&custlinkid=664887)
* Use a 32Gb size SD card (recommended by Home Assistant).

## My setup

{{< figure src="/goosst/pictures/ebus_wemos.jpg" title="Wemos mini D1 and ebus adapter mounted on heater" width="350">}}

* [Wemos mini D1](https://www.banggood.com/Geekcreit-D1-Mini-V3_0_0-WIFI-Internet-Of-Things-Development-Board-Based-ESP8266-4MB-p-1264245.html?p=ET150713234951201708&custlinkid=734961) and ebus-adapter (without uart interface) are mounted against the heater by using velco strips
* The white and purple wire are the ebus, they are connected inside the heater (ebus protocol has no polarity, so you can swap the wires)
* ebus-adapter is connected through five wires as described [here](https://ebus.github.io/adapter/images/wemos-wiring-v21.jpg)

# Software

## Software Wemos D1 mini

A special software is created by john30, the procedure to start using it is described on [his github page](https://github.com/john30/ebusd-esp).
There is not much too add here.

## ebusd

First install the ebus related software on your system running your home automation, see the ebus section in the [installation guide]({{< relref "hass_laptop.md" >}}).

If this is done, adapt your ebus configuration to match your wemos settings:

* Check the settings in the interface of the wemos / ebus adapter, the ebusd device string is what you'll need in the next step.
{{< figure src="/goosst/pictures/ebusd_adapter_wemos_sw.png" title="Interface when browsing to wemos D1 mini" width="350">}}
* adapt the ebus configuration on your host, as described in the following steps:
```
cd /etc/default
sudo nano ebusd
```
Adapt the EBUSD_OPTS in the file, so you get something like the example below. (Pending your internet connection / hardware you might have to play with the latency parameters.)
```
# /etc/default/ebusd:
# config file for ebusd service.

# Options to pass to ebusd (run "ebusd -?" for more info):
#EBUSD_OPTS="--scanconfig"
EBUSD_OPTS="-d 192.168.0.193:9999 -l /var/log/ebusd.log --scanconfig --latency=100000 --address=01"
# MULTIPLE EBUSD INSTANCES WITH SYSV
# In order to run multiple ebusd instances on a SysV enabled system, simply
# define several EBUSD_OPTS with a unique suffix for each. Recommended is to
....
```
Do a restart of the ebusd and check its status:
```
sudo systemctl restart ebusd
sudo systemctl status ebusd
```

The output should look like this:
```
● ebusd.service - ebusd, the daemon for communication with eBUS heating systems.
   Loaded: loaded (/lib/systemd/system/ebusd.service; enabled; vendor preset: enabled)
   Active: active (running) since Sat 2019-12-21 16:45:54 UTC; 56min ago
  Process: 3221 ExecStart=/usr/bin/ebusd $EBUSD_OPTS (code=exited, status=0/SUCCESS)
 Main PID: 3222 (ebusd)
    Tasks: 4 (limit: 4749)
   Memory: 1.5M
   CGroup: /system.slice/ebusd.service
           └─3222 /usr/bin/ebusd -d 192.168.0.193:9999 -l /var/log/ebusd.log --scanconfig --latency=100000 --address=01

Dec 21 16:45:54 tinkerboard systemd[1]: Starting ebusd, the daemon for communication with eBUS heating systems....
Dec 21 16:45:54 tinkerboard systemd[1]: Started ebusd, the daemon for communication with eBUS heating systems..
```
check if your heating system is identified by running `ebusctl info`:
```
xxx@tinkerboard:~$ ebusctl info
version: ebusd 3.4.v3.3-51-g57eae05
update check: revision v3.4 available
signal: acquired
symbol rate: 42
max symbol rate: 102
min arbitration micros: 20
max arbitration micros: 177
min symbol latency: 6
max symbol latency: 80
reconnects: 0
masters: 3
messages: 345
conditional: 2
poll: 0
update: 9
address 01: master #6, ebusd
address 03: master #11
address 06: slave #6, ebusd
address 08: slave #11, scanned "MF=Vaillant;ID=BAI00;SW=0202;HW=9602", loaded "vaillant/bai.0010015600.inc" ([HW=9602]), "vaillant/08.bai.csv"
address 10: master #2
address 15: slave #2, scanned "MF=Vaillant;ID=F3700;SW=0114;HW=6102", loaded "vaillant/15.f37.csv"
```

Query some commands to see if everything is working as expected.

```
xxx@tinkerboard:~$ ebusctl read RoomTemp
21.00;ok

xxx@tinkerboard:~$ ebusctl read Hc1DayTemp
21.0
```

## Debugging

Useful commands to debug can be `tail -30 /var/log/ebusd.log`, this to see what ebus has been written to the log file configured in EBUSD_OPTS.
