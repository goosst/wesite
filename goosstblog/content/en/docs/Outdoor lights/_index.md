
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

My outdoor lights give power outages when it rains a lot, the differential switch triggers (even when not turned on). 
Since the underground wiring cannot be easily fixed, a workaround was done by also switching the neutral wire going to the lights when power down.

# Concept

{{< figure src="/pictures/OutdoorLighting.png" title="Double Sonoff switches" width="500">}}

Tasmota settings:
* PowerOnState 1
* WifiConfig 5
* SetOption1 1
* SetOption13 1

Since the module is hidden in an electric box, the button is disabled for certainty.

{{< figure src="/pictures/terrasverlichting.png" title="Tasmota config" width="350">}}





