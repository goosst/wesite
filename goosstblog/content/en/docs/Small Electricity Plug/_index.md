
---
title: "Small Electricity plug"
linkTitle: "Small Electricity plug"
weight: 6
date: 2022-08-15
description: >
  Honking at the moles
tags:
 - mole repelling
 - claxon
 - horn
 - honking
 - home assistant
---

{{% pageinfo %}}
Creating a narrow as possible electricity plug (to integrate behind a mirror).
{{% /pageinfo %}}

# Goal

I wanted to integrate an electricity plug behind my mirror, which only has a few centimeters of width between the glass and the wall. Only two pins are needed, no ground. I didn't immediately find a solution that was - easily - commercially available.


# Concept

# Realization 

Used components:
* [EU to US travel adapter](https://amzn.to/3dwTqR8), which will be dismantled and replaced by the 3d-printed part.
* [US to EU travel adapter](https://amzn.to/3w5POMk)
* 3d printed parts, [openscad file](https://www.goosst.com/others/NarrowElectricityPlug.scad):
** a new housing for the EU to US adapter, internals are just transferred without modification
** a counter piece for the above cover (the two pieces slide in each other)
** an (option) drilling guide to have the four drilled holes (two for screws, two for the electricity pins) somewhat decently aligned
* female flat electricity socket to connect the 230V to


## Putting it together

* Move the internals from one [EU to US travel adapter](https://amzn.to/3dwTqR8) to the 3d printed part.
* Drill two M4 holes for mounting, drilling two M6 holes for the guidance of the electricity pins

{{< figure src="/pictures/ElectricityPlug.png" title="Enclosure" width="350">}}

{{< figure src="/pictures/ElectricityPlug2.png" title="Enclosure" width="350">}}

Could you get rid of the second US-EU conversion, probably yes ... . But feel free to mod.



