---
author: "goosst"
date: 2019-09-29
title: e-paper - Extension to two displays
tags:
 - ESP32
 - TTGO
 - waveshare
 - 7.5 inch
 - home assistant
---


# Intro
In this part, the esp32 software will be extended to control two displays.
The described solution mainly comes because of the great support from the creator of [gxEPD2](https://github.com/ZinggJM/GxEPD2), so credits to him.

# Hardware struggles
The used [7.5 inch display](https://www.banggood.com/Waveshare-7_5-Inch-E-ink-Screen-Module-e-Paper-Display-SPI-Interface-For-Arduino-Raspberry-Pi-p-1365278.html?p=ET150713234951201708&custlinkid=591953), comes with an e-Paper Driver HAT.
When connecting it as intended - 3.3V of this [ESP32](https://www.banggood.com/LILYGO-TTGO-T-Energy-ESP32-8MByte-PSRAM-WiFi-bluetooth-Module-18650-Battery-ESP32-WROVER-IB-Development-Board-p-1427125.html?p=ET150713234951201708&custlinkid=591947) connected to the 3.3 V of the e-paper HAT - it turns out very unreliable.
It becomes more unreliable when combining more than one e-paper to the display (or it can be my cognitive bias).  

The solution is to bypass the voltage converter and directly connect the 3.3V from the ESP32 according the picture below (see [scematics](https://www.waveshare.com/w/upload/8/87/E-Paper-Driver-HAT-Schematic.pdf)):
{{< figure src="/goosst/pictures/epaper_hat.png" title="Alternative 3.3V connection" width="300">}}

# Software ESP32

## SPI
One common SPI is used for both displays; the busy, reset and CS pin are separate pins for each display.
(Using two different SPI's for both displays, was too much work to make it work.)

```
#define ENABLE_GxEPD2_GFX 1
#include <GxEPD2_BW.h>

//SPI pins, common for both displays
static const uint8_t EPD_DC   = 22; // to EPD DC
static const uint8_t EPD_SCK  = 18; // to EPD CLK
static const uint8_t EPD_MISO = 19; // Master-In Slave-Out not used, as no data from display
static const uint8_t EPD_MOSI = 23; // to EPD DIN

// display two:
static const uint8_t EPD_BUSY2 = 4;  // to EPD BUSY
static const uint8_t EPD_CS2   = 5;  // to EPD CS
static const uint8_t EPD_RST2  = 21; // to EPD RST
GxEPD2_BW<GxEPD2_750, GxEPD2_750::HEIGHT> display2(GxEPD2_750(/*CS=*/ EPD_CS2, /*DC=*/ EPD_DC, /*RST=*/ EPD_RST2, /*BUSY=*/ EPD_BUSY2));   // B/W display

//display one:
static const uint8_t EPD_BUSY1 = 25;  // to EPD BUSY
static const uint8_t EPD_RST1  = 34; // to EPD RST
static const uint8_t EPD_CS1   = 15;  // to EPD CS
GxEPD2_BW<GxEPD2_750, GxEPD2_750::HEIGHT> display1(GxEPD2_750(/*CS=*/ EPD_CS1, /*DC=*/ EPD_DC, /*RST=*/ EPD_RST1, /*BUSY=*/ EPD_BUSY1));   // B/W display

```

## Displaying
Two images are downloaded now, one for each display: black1.bmp and black2.bmp

Full script is available on [github](https://github.com/goosst/HomeAutomation/blob/master/esp32_epaper/bmp_http_twodisp.ino).


# Software Home assistant

Generate black1.bmp image
