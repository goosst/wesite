---
author: "goosst"
date: 2019-12-22
title: Remote control from Android
tags:
 - Macrodroid
 - curl
 - Rest API
 - armbian
 - debian
 - tor
 - home assistant
 - torrc
 - Orbot
 - Orfox
 - home automation
weight: 10
---

# Intro
This is the continuation of [HomeAssistant Tor]({{< ref "hass_tor.md" >}}). Here we'll create a macro to automatically turn our heating on/off from an Android phone. The end result is something which only requires two / three pushes on a button on your android phone to turn on my heating.
It works when being connected to a mobile network as well as a wifi network.

# Method and tools

* Macrodroid: Android app used for creating the macro. It's free and can do everything we need.
* Curl commands will be created making use of the [REST API from home assistant](https://developers.home-assistant.io/docs/en/external_api_rest.html)
* You need a long-lived access token from HomeAssistant. It can be obtained by browsing to http://ip_addr_hass:8123/profile and creating one.

Additional tools to make debugging easier on your phone: Termux

# Macro creation

## Home Assistant

In `configuration.yaml`:
* an input_boolean with the name turn_heating_on is defined
* an automation is defined if we see a change from off to on in this variable, an action is defined that runs an automation to turn our heating on

```
input_boolean:
  turn_heating_on:
    name: Heating Living Day
    initial: off
```

```
automation turn_heating_on_living:
  - alias: 'turn heating living on'
    trigger:
      platform: state
      entity_id: input_boolean.turn_heating_on
      from: 'off'
      to: 'on'
    action:
      - service: shell_command.set_temp_high
        data:
          message: "Turned living heating on"
      - delay: '00:01:00'
      - service: shell_command.read_ebus
```

## shell script

* Open Macrodroid --> Add macro
* Add an "action" of the type "Applications-Shell Script"
* Create a curl command to change the state of turn_heating_on to off or on
```
curl  \
-X POST --socks5-hostname localhost:9150 http://xxxxx.onion/api/states/input_boolean.turn_heating_on \
-H "Authorization: Bearer
here_is_your_very_long_lived_token" \
-H "Content-Type: application/json" \
-d '{"state": "off"}'
```
{{< figure src="/pictures/macrodroid_shellscript.png" title="Macrodroid shell script" width="200">}}
* Start Orbot / Tor
* Test your shell script and play with the "state" attribute, you should see the turn_heating_on change accordingly ("off"/"on")

## Incorporate in larger macro

* Create a larger macro which starts and stops Orbot automatically.
* Since my home automation assumes a change from "off" to "on", the turn_heating_on will be first put "off" and then put to "on"
{{< figure src="/pictures/macrodroid_macro.png" title="Macrodroid macro" width="200">}}

The end result is, I need two/three pushes on the screen to turn my heating on:

* First push: start the macro
* Second push: when the orbot screen launches, push the big onion to connect to the tor network
* Optional third push: when the orbot screen launches for the second time, disconnect from the tor network
