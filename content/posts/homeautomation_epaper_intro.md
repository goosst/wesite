---
author: "goosst"
date: 2019-09-15
title: e-paper display Intro
tags:
 - home assistant
 - display
 - ESP32
 - TTGO
 - waveshare
 - 7.5 inch
---

# Intro
<!-- {{< figure src="/goosst/pictures/epaper_display.jpg" title="E-paper display linked with Home Assistant" width="760">}} -->

{{< figure src="/goosst/pictures/epaper_display1.jpg" title="E-paper display linked with Home Assistant" width="700">}}

I wanted a display which:

- does not consume (a lot of) electricity
- is linked with home-assistant, so I can get useful updates pending the moment of the day
- can display interesting photos, when I don't want to know the status of my house / surroundings :)
- doesn't cost an arm and a leg

The result of my tinkering can be seen in the picture above.

I've used two 7.5 inch e-paper displays and incorporated them into a picture frame. The reason for two dislays is mainly because larger e-papers just become very expensive. Obviously you don't need two, if you don't want to... .

# Concept

In the following posts, the different parts of the display are explained in more detail:

- [General concept] ( {{< relref "homeautomation_epaper_gen.md" >}})
- [Control e-paper with ESP 32] ( {{< relref "homeautomation_epaper_ESP.md" >}})
- [Home assistant: content creation] ({{<relref "homeautomation_epaper_HASS">}})

All code is available at: [github](https://github.com/goosst/HomeAutomation)



# Remarks and Todo

- I should not have bought an ESP32 board including an 18650 battery: this types of batteries is barely available in Europe + if I want it battery operated I can just attach a powerbank, there is more than enough space in the picture frame.
- Still need to get the second screen up and running (using the same ESP32 board)
- add description of construction
