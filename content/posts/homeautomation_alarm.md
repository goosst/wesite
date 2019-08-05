---
author: "goosst"
date: 2019-05-10
title: Heating automation - alarm
tags:
 - wemos D1
 - home assistant
 - raspberry pi
---

{{% toc %}}

# Intro

I've let a relay install during yearly maintenance of my alarm, this allows me to tell me when the alarm is turned on or off. This makes life for presence detection significantly more simple :). 

We'll use MQTT to send status of alarm to Home Assistant. 

## Troubleshooting

The connection of a Wemos D1 with Arduino IDE seems to be junk. We need to use esptool instead
`pip3 install esptool`

structure to use:
`esptool --port "{serial.port}" --baud {upload.speed} write_flash 0x00000 "{build.path}/{build.project_name}.bin`

## To do

