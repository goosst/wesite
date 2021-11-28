
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

Outdoor lights give power outages, differential switches trigger when not turned on. 
Since the underground wiring cannot be easily fixed, a workaround was done by also switching the Neutral while inactive.

# Concept

{{< figure src="/pictures/OutdoorLighting.png" title="Outdoor lighting switches" width="500">}}

Tasmota settings:
* PowerOnState 1
* WifiConfig 5

Since the module is hidden in an electic box, the button is disabled for certainty.

{{< figure src="/pictures/terrasverlichting.png" title="Outdoor lighting switches" width="350">}}






