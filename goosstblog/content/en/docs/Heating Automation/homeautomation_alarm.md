---
author: "goosst"
date: 2019-05-10
title: Link with house alarm
tags:
 - wemos D1
 - home assistant
 - raspberry pi
---


# Intro

I've let a relay install during yearly maintenance of my burglar alarm, this allows me to tell me when the alarm is turned on or off. This makes life for presence detection significantly more simple :).

We'll use MQTT to send status of alarm to Home Assistant.

## Troubleshooting

The connection of a [Wemos D1](https://www.banggood.com/Geekcreit-D1-R2-V2_1_0-WiFi-Uno-Module-Based-ESP8266-Module-For-Arduino-Nodemcu-Compatible-p-1085610.html?p=ET150713234951201708&custlinkid=664901) with Arduino IDE seems to be junk (the arduino IDE part). We need to use esptool instead
`pip3 install esptool`.

structure to use:
`esptool --port "{serial.port}" --baud {upload.speed} write_flash 0x00000 "{build.path}/{build.project_name}.bin`

## Used script

[Location](https://github.com/goosst/HomeAutomation/blob/master/wemos/sketch/sketch.ino)
Can be updated over the air (ota), so you only have to fysically connect it once (in theory at least, if everything uploads correctly)
