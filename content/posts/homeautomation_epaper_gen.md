---
author: "goosst"
date: 2019-09-16
title: e-paper display concept
tags:
 - home assistant
 - display
 - ESP32
 - TTGO
 - waveshare
 - 7.5 inch
---

# Intro
This part sketches the entire flow. I've changed my method a few times during the creation of this. Mainly because I just stumble upon things in the home assistant documentation, rather than actually finding something when I need it :).

# Different steps

{{< figure src="/goosst/pictures/epaper_hass.png" title="Sequence to get home assistant content on e-paper " width="350">}}

Relevant references to documentation (I want to find it back myself ;):

- [Home Assistant: External files](https://www.home-assistant.io/components/http/#hosting-files)
- [Home Assistant: REST API](https://developers.home-assistant.io/docs/en/external_api_rest.html#get-apihistory)

Remarks:

- I'm using [hassbian](https://www.home-assistant.io/docs/installation/hassbian/installation/) on a raspberry pi 3, I have not checked if anything should change when using hassio and other variants
- the REST API, would allow to do everything on the esp32, but I didn't go that route ... .
