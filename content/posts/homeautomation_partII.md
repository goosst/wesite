---
author: "goosst"
date: 2019-04-20
title: Vaillant automation part II
---

# Intro
In this part we'll send commands through the interface of Home Assistant. 

There is hassbian, hass.io, homme-assistant itself, ... as you see, it's not confusing at all :). I'm using hassbian since at least I know ebusd works in a debian environment on the raspberry pi. I'm not familiar with docker (hass.io) and its limitations.


# Preparing the Raspberry pi

- Follow the Hassbian installation instructions: https://www.home-assistant.io/docs/installation/hassbian/installation/

- Additional installations beside the normal updating, upgrading, setting the time-zone: 

```
sudo apt-get install net-tools nmap
sudo hassbian-config install mosquitto
sudo hassbian-config install samba
```
An overview of other helper scripts can be found at: https://github.com/home-assistant/hassbian-scripts


To be continued



{{< ama1 >}}

