---
author: "goosst"
date: 2019-04-19
title: Heating automation - setup hardware and ebus
tags:
 - vaillant
 - ecotec plus
 - ebus
 - home assistant
 - raspberry pi
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

## Raspberry pi
Please use a decent power supply (it causes a lot of strange problems) and 32Gb size SD card (recommended by Home Assistant).

## My setup

{{< figure src="/goosst/pictures/IMG_20190420_092754.jpg" title="Raspberry pi and ebus adapter mounted on heater" width="350">}}

* Pi and ebus-adapter are mounted against the heater by using velco strips
* A case, specific for the raspberry pi is used
* The white and purple wire are the ebus, they are connected inside the heater (ebus protocol has no polarity, so you can swap the wires)
* ebus-adapter is connected through usb with the raspberry pi

# Software

## Preparing the Raspberry pi
If you have a pi with raspbian already on it, you can jump to next section and install hassbian later. If you have a new sd card, just set it right from the first time.

We'll be using Home Assistant for our interface and home automation.
I chose Home Assistant because it's fully python based. I prefer to learn python over learning Java, Perl, ... which is used by the alternative open source domotica programs. 

### Hassbian 
To use Home Assistant, there is hassbian, hass.io, home-assistant itself, ... as you see, it's not confusing at all :). I'm using hassbian since at least I know ebusd works in a debian environment on the raspberry pi. (https://www.home-assistant.io/docs/installation/hassbian/installation/)

Additional installations beside the normal updating and upgrading: 
```
sudo apt-get install net-tools nmap
sudo hassbian-config install mosquitto
sudo hassbian-config install samba
```

### Static IP address

Since we will be sending quite some messages from other devices through MQTT, a static IP address is rather convenient. I've followed the steps from this link (my routher doesn't support fancy things)	: 
https://raspberrypi.stackexchange.com/questions/37920/how-do-i-set-up-networking-wifi-static-ip-address/74428#74428


## install and use ebusd

Ebusd is an awesome tool, it's a challenge however to find out how to efficiently use it :).

* Go to your raspberry pi by ssh'ing to it
* Follow these instructions: https://github.com/john30/ebusd-debian/blob/master/README.md
* I've had some weird issues that magically got resolved, I still think it's linked to a strange power supply : https://github.com/john30/ebusd/issues/276
* Check on the raspberry with the command: `dmesg | grep cp210` if the adpater is added to ttUSB0 (only relevant if you're using cp210 as uart device of course: <a target='_blank' href='https://www.banggood.com/CJMCU-CP2102-USB-To-TTLSerial-Module-UART-STC-Downloader-p-970993.html?p=ET150713234951201708&custlinkid=261938' title='' >CP2102 USB To TTL/Serial Module</a>) 
output should look something like this:

```
pi@raspberrypi:/ $ dmesg | grep cp210
[    3.826051] usbcore: registered new interface driver cp210x
[    3.826168] usbserial: USB Serial support registered for cp210x
[    3.834271] cp210x 1-1.3:1.0: cp210x converter detected
[    3.856013] usb 1-1.3: cp210x converter now attached to ttyUSB0

```
* The magic ebusd command is: `ebusd -f --scanconfig`, ebusd should find your connected devices (a wireless thermostat and a vaillant heater in my case), output looks something like the one below. If you don't see any read messages something is wrong and you need to start debugging.
```
pi@raspberrypi:/ $ ebusd -f --scanconfig
2019-03-31 13:30:47.528 [main notice] ebusd 3.3.v3.3 started with auto scan
2019-03-31 13:30:47.875 [bus notice] bus started with own address 31/36
2019-03-31 13:30:47.897 [bus notice] signal acquired
2019-03-31 13:30:48.146 [bus notice] new master 03, master count 2
2019-03-31 13:30:53.347 [bus notice] new master 10, master count 3
2019-03-31 13:30:53.410 [update notice] received unknown MS cmd: 1008b5110101 / 093d3c008033390000ff
2019-03-31 13:30:54.523 [update notice] received unknown MS cmd: 1008b5040100 / 0a00ffffffffffffff0080
2019-03-31 13:30:55.347 [update notice] received unknown BC cmd: 10feb51603010000
2019-03-31 13:30:57.436 [update notice] received unknown MS cmd: 1008b51009000000ffffff45ff00 / 0101
2019-03-31 13:30:58.038 [bus notice] scan 08: ;Vaillant;BAI00;0202;9602
2019-03-31 13:30:58.039 [update notice] store 08 ident: done
2019-03-31 13:30:58.039 [update notice] sent scan-read scan.08  QQ=31: Vaillant;BAI00;0202;9602
2019-03-31 13:30:58.039 [bus notice] scan 08: ;Vaillant;BAI00;0202;9602
2019-03-31 13:30:58.565 [main notice] read common config file vaillant/scan.csv
2019-03-31 13:30:58.780 [main notice] read common config file vaillant/general.csv
2019-03-31 13:30:58.918 [main notice] read common config file vaillant/broadcast.csv
2019-03-31 13:30:59.001 [main notice] read scan config file vaillant/08.bai.csv for ID "bai00", SW0202, HW9602
2019-03-31 13:30:59.576 [update notice] sent scan-read scan.08 id QQ=31: 
2019-03-31 13:30:59.756 [update notice] sent scan-read scan.08 id QQ=31: 
2019-03-31 13:30:59.936 [update notice] sent scan-read scan.08 id QQ=31: 
2019-03-31 13:31:00.117 [update notice] sent scan-read scan.08 id QQ=31: 21;17;09;0010011632;1300;378112;N5
2019-03-31 13:31:00.478 [main notice] found messages: 198 (2 conditional on 24 conditions, 0 poll, 9 update)
2019-03-31 13:31:00.645 [update notice] sent scan-read scan.08 id QQ=31: 21;17;09;0010011632;1300;378112;N5
2019-03-31 13:31:00.827 [update notice] sent scan-read scan.08 id QQ=31: 21;17;09;0010011632;1300;378112;N5
2019-03-31 13:31:01.010 [update notice] sent scan-read scan.08 id QQ=31: 21;17;09;0010011632;1300;378112;N5
2019-03-31 13:31:01.189 [update notice] sent scan-read scan.08 id QQ=31: 21;17;09;0010011632;1300;378112;N5
2019-03-31 13:31:01.190 [bus notice] scan 08: ;21;17;09;0010011632;1300;378112;N5
2019-03-31 13:31:03.350 [bus notice] scan 15: ;Vaillant;F3700;0114;6102
2019-03-31 13:31:03.350 [update notice] store 15 ident: done
2019-03-31 13:31:03.350 [update notice] sent scan-read scan.15  QQ=31: Vaillant;F3700;0114;6102
2019-03-31 13:31:03.350 [bus notice] scan 15: ;Vaillant;F3700;0114;6102
2019-03-31 13:31:03.581 [update notice] sent unknown MS cmd: 3115b5090124 / 09013231313732323030
2019-03-31 13:31:03.761 [update notice] sent scan-read scan.15 id QQ=31: 
2019-03-31 13:31:03.941 [update notice] sent scan-read scan.15 id QQ=31: 
2019-03-31 13:31:04.002 [bus notice] max. symbols per second: 114
2019-03-31 13:31:04.120 [update notice] sent scan-read scan.15 id QQ=31: 21;17;22;0020108149;0082;006391;N9
2019-03-31 13:31:04.120 [bus notice] scan 15: ;21;17;22;0020108149;0082;006391;N9
2019-03-31 13:31:04.518 [main notice] read scan config file vaillant/15.f37.csv for ID "f3700", SW0114, HW6102
2019-03-31 13:31:04.858 [main notice] found messages: 345 (2 conditional on 24 conditions, 0 poll, 9 update)
2019-03-31 13:31:05.428 [update notice] received read bai Status02 QQ=10: on;60;75.0;70;65.0
2019-03-31 13:31:07.472 [update notice] received update-write bai SetMode QQ=10: auto;0.0;-;-;1;0;1;0;0;0
2019-03-31 13:31:13.444 [update notice] received read bai Status01 QQ=10: 30.5;30.0;-;25.5;28.5;off
2019-03-31 13:31:17.474 [update notice] received update-write bai SetMode QQ=10: auto;0.0;-;-;1;0;1;0;0;0
```

* Make sure ebusd starts up when the raspberry boots: https://github.com/john30/ebusd/wiki/2.-Run
* In parallel commands with ebusctl can be queried
```
pi@raspberrypi:~ $ ebusctl info
version: ebusd 3.3.v3.3
signal: acquired
symbol rate: 23
max symbol rate: 114
min arbitration micros: 3217
max arbitration micros: 3341
min symbol latency: 4
max symbol latency: 5
reconnects: 0
masters: 3
messages: 345
conditional: 2
poll: 0
update: 9
address 03: master #11
address 08: slave #11, scanned "MF=Vaillant;ID=BAI00;SW=0202;HW=9602", loaded "vaillant/bai.0010015600.inc" ([HW=9602]), "vaillant/08.bai.csv"
address 10: master #2
address 15: slave #2, scanned "MF=Vaillant;ID=F3700;SW=0114;HW=6102", loaded "vaillant/15.f37.csv"
address 31: master #8, ebusd
address 36: slave #8, ebusd
```
In this output you can find back the names f37 and bai, the devicenames needed for further usage in ebusd.

* You have to look up the mentioned csv files (e.g. 15.f37.csv) to see which parameters are available, which parameters have read permission (r), which have write permissions (w), ... . The configuration files are stored on another github site from john30:  https://github.com/john30/ebusd-configuration/tree/master/ebusd-2.1.x/en/vaillant

* Once ebus is running open a second terminal on the pi and read and write all the things you want to do:

 * Read example, here we read the time reported by the thermostat:

```
ebusctl read Time
14:30:30
```
 * Write example, writing the time to the thermostat:

```
pi@raspberrypi:~ $ ebusctl write -c f37 Time 14:00:00
done

pi@raspberrypi:~ $ ebusctl read Time
14:00:02
```

 * play around with other relevant parameters from the .csv sheet:
  * `ebusctl read Hc1DayTemp`, read and write your temperature setpoint during day time
  * `ebusctl read Hc1NightTemp`, read and write your temperature setpoint during night time
  * `ebusctl read RoomTemp`, read the temperature measured by the thermostat
  * and a whole bunch of others ... 

{{< ama3 >}}
