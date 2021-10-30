---
author: "goosst"
date: 2019-04-18
title: Heating automation - intro
tags:
 - vaillant
 - ecotec plus
 - ebus
 - home assistant
 - raspberry pi
weight: 1
---


# Goal

If your goal is to remove your thermostat completely, that's not going to happen in this blog.

The posts provide guidance how to add additional intelligence and monitoring to our setup and serve as documentation for myself and others. It's not a dummy proof step-by-step guide.

# Tools

We'll be using the following hardware and software:

1. A debian based system ( (old) laptop, tinkerboard, [Raspberry pi 3b](https://www.banggood.com/Raspberry-Pi-3-Model-B-Plus-Mother-Board-Mainboard-With-BCM2837B0-Cortex-A53-ARMv8-1_4GHz-CPU-D-p-1278398.html?p=ET150713234951201708&custlinkid=664885), ...)
2. ebus adapter: https://ebus.github.io/adapter/index.en.html
3. ebusd software: https://github.com/john30/ebusd
4. Home Assistant: https://www.home-assistant.io/

Ebus is the communication protocol used by a lot of heating systems, we'll have to tap into this communication system to help our thermostat become more intelligent.

It's fair to say without the ebusd software this project would never have happened.

My latest files can be found here: https://github.com/goosst/HomeAutomation

# Setup

My setup is rather simple:

1. Vaillant ecotec plus: heats one room 
2. Wireless thermostat, Calormatic 370f

(in 2021 it got extended with other rooms having floor heating and a different thermostat, all still works in the same way :) )


{{< figure src="/pictures/IMG_20190420_091458.jpg" title="Vaillant ecotec plus" width="350">}}
{{< figure src="/pictures/IMG_20190420_112454.jpg" title="Vaillant wireless thermostat, Calormatic 370f" width="350">}}

# Getting started

* [Software installation on debian based system]({{< relref "hass_laptop.md" >}})
* [Hardware and communication to heater]({{< relref "homeautomation_wemos_ebus.md" >}})
* [Set temperatures through Home Assistant]({{< relref "homeautomation_partII.md" >}})
* [Reading additional information through Home Assistant]({{< relref "homeautomation_partIII.md" >}})
