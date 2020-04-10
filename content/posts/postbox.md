---
author: "goosst"
date: 2020-04-10
title: Mail detection
tags:
 - wemos d1 mini
 - home assistant
 - mail box
 - vl53l0x
 - letter received

---

{{% toc %}}

# Goal

Get notified when a letter / package is in your mail box (the real mail, not e-mail).

# Hardware
- VL53L0X sensor, measures the distance accurately according the time-of-flight principle
- wemos D1 mini, to connect to wifi (and send an mqtt message)
- Batteries

# Software: Tasmota

We'll be using the awesome tasmota to flash to the wemos D1 `https://tasmota.github.io/docs/Builds/`.

Since the sensor VL53L0X is not included in the default builds, a custom build has to be made:
- Install platformio and downloading the tasmota source, according `https://tasmota.github.io/docs/Create-your-own-Firmware-Build-without-IDE/``
```
virtualenv platformio-core
pip install -U platformio
pip install --upgrade pip
git clone https://github.com/arendst/Tasmota.git
cd Tasmota/
```
- Edit 'my_user_config.h' by uncommenting '#define USE_VL53L0X' in the file.
- Build by executing: `time pio run 2>&1 | tee build.log`
- Wait till the build has finished ... 
