---
author: "goosst"
date: 2019-04-22
title: Heating automation - device tracking
tags:
 - vaillant
 - ecotec plus
 - ebus
 - home assistant
 - raspberry pi
---

# Intro
In this part we'll turn our heating off and on when we leave the house (by detecting presence of our mobile phone).


# Concept

We'll be checking if the mac-address of our phone is on the wifi network. Based on this we'll do a simple scheduling of our heating.

# Home assistant

No python scripts this time, only activity is done in Home Assistant.

## Device tracking

Example below will use the component `device_tracker` and the nmap program to scan the network.

```
#NMAP is unreliable without scan_options
device_tracker:
  - platform: nmap_tracker
    hosts: 192.168.0.1-254
    consider_home: 600
    interval_seconds: 180
    scan_options: " -min-rtt-timeout 3s " #scan_options: " -min-rtt-timeout 3s --privileged -sP "
```

* it will scan all ip-addresses 192.168.0.x 
* an additional scan option has been added to increase the minimum timeout, detection on my wireless network does not seem to work reliably without this option.
* starts a scan every 180 seconds


## Identify phone

When Home Assistant starts scanning:

* automatically new devices will start popping up in your user interface, easiest way is to go to the states overview:
{{< figure src="/goosst/pictures/devicetracker.png" title="States device tracker" width="760">}}
* to check which ip address your phone has, you can look it up on the phone
 * in Android: Settings -> About phone -> Status
 * or disable and enable the wifi on your phone and see which ones gets the status away in your home assistant interface (requires more patience)
* in your folder `/home/homeassistant/.homeassistant` a file `known_devices.yaml` will list all discovered devices
* give a more decent name to the address linked to your phone (e.g. phone Jane)

```
5c_35_3b_70_05_29:
  hide_if_away: false
  icon:
  mac: 5C:35:3B:70:05:29
  name: phone Jane
  picture:
  track: true
```

* You should disable tracking (`track:false`) for the devices you are not interested in


## turn off heating when leaving

Examples below

* Set temperature setpoint low when phone went from home to not home:

```
automation leaving_house:
  alias: set temp low when leaving house
  trigger:
    platform: state
    entity_id: device_tracker.5c_35_3b_70_05_29
    from: 'home'
    to: 'not_home'
  action:
    service: shell_command.set_temp_low
    data:
      message: "Jane left house: heating low"
```

* Set temperature setpoint high when phone is present and it's between 6:30 and 22:30.
Every five minutes a new check on the home status is done.

```
automation at_home:
  alias: set temp high when being home
  trigger:
    platform: time_pattern
    minutes: '/5'
  condition:
    condition: and
    conditions:
      - condition: time
        after: '06:30:00'
        before: '22:30:00'
      - condition: state
        entity_id: device_tracker.5c_35_3b_70_05_29
        state: 'home'
  action:
    service: shell_command.set_temp_high
    data:
      message: "Jane is home: heating high"
```




{{< ama2 >}}

{{< ama1 >}}

