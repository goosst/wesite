
---
title: "Outdoor lighting"
linkTitle: "Outdoor lighting"
weight: 10
date: 2021-11-28
description: >
  Switches outdoor light with sonoff flashed with tasmota
---

{{% pageinfo %}}
Switches outdoor light with sonoff flashed with tasmota
{{% /pageinfo %}}

# Goal

My outdoor lights give power outages when it rains a lot, the differential switch triggers (also when ligbts are not turned on). 
Since the underground wiring cannot be easily fixed, a workaround was done by also switching the neutral wire going to the lights when power down.

# Concept

{{< figure src="/pictures/OutdoorLighting.png" title="Double Sonoff switches" width="500">}}

Tasmota settings:
* PowerOnState 1: if the tasmota devices get power, they will turn on the lights automatically.
  * When the first tasmota gets turned on (by a manual switch or by homeautomation), the second tasmota will be turned on. When the second tasmota receives power it will turn on the lights automatically.
* WifiConfig 5
* SetOption1 1
* SetOption13 1

Since the module is hidden in an electric box, the buttons on the tasmotas are disabled for certainty.

{{< figure src="/pictures/MoleHonking.jpg" title="The different components" width="350">}}






