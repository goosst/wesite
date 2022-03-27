
---
title: "Repelling Moles"
linkTitle: "Repelling Moles"
weight: 6
date: 2022-03-27
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
Honking at the moles (to repel them)
{{% /pageinfo %}}

# Goal

My garden got terrorized by moles over the winter. My mole traps were not effective, so I had to come up with another solution.


# Concept

It has been proven moles get repelled by sound. The typical sound of these repelling devices [exanple](https://amzn.to/3JJoisI) is in a frequency range of around 300-1000 Hz.
These typical solar powered devices only produce a few watt of power, so I decided to take it up a notch ... .

Burrying an audio speaker and tune the sound with an amplifier was an option, but that seemed a bit more costly and complex to automate (don't want to produce non stop 24/7 noise) and get the necessary equipment in the garden.
The typical horn / claxon of an automotive application is also in the same frequency range of 350Hz but produces much higher power levels. This is a cheap solution and only requires an on/off type of automation. Typical motorcycle claxons just have a vibrating disk actuated by 12V. As we know from hearing beeping watches under water, sound travels better through solids and liquids than it does through air.

# Realization 

Used components:
* [Automotive horn](https://amzn.to/3Dfz7QN), to give an idea about the sound level: it's the horn of a scooter. You could also go for a [double variant](https://amzn.to/3DjVtAW).
* [Connectors](https://amzn.to/3iKAD3S)
* Power supply providing a voltage between 9-16 V (capable of driving ~40 watt), I still had a 15V, 10A supply lying around so didn't buy a new one (mine is link [this](https://amzn.to/3IOejkC)).
* Smart switch to control the power supply and control the periodic honking at the moles [Example Sonoff S26](https://amzn.to/3DdPc9Q)
* Plastic box to shield the horn from dirt. I've 3d-printed one, but any box can do.
* Power chord 


## Putting it together

An enclosure was 3d-printed so the claxon is protected and the steel disk remains free to vibrate (and hence produce sound), of course you can just use any other platic box. 
Note: just wrapping it in a plastic bag will not be sufficient: if something prevents oscillation of the steel disk, no sound will be produced anymore (ask me how I now ...).
In the 3d-printed enclosure a small hinge was designed so the horn is kept in place inside the box. Files for the enclosure can be found here: [stl file](https://www.goosst.com/others/C%20_fakepath_firstBox2.stl), [openscad file](https://www.goosst.com/others/C%20_fakepath_firstBox.scad).
I just can't find the thingiverse source back where I modified this box from :(.

{{< figure src="/pictures/EnclosureMoleHonk.png" title="Enclosure" width="350">}}

Wiring with matching connectors and power supply was done, et voila: ready to honk. Just don't test it next to your ears ... .
{{< figure src="/pictures/MoleHonking.jpg" title="The different components (power supply, horn, platic enclosure, connectors)" width="550">}}


## Ground works

Installation was tried at different depths under the ground. I had to dig it in at a depth of ca. 80cm before the outside sound was judged low enough to not annoy my neighbours. Sound does travel better in solids than it does in air :).
The wiring and connector was installed downwards so no debris will enter the enclosure by gravity.


## Automation

The claxon cannot be turned on cotinuously. So a small automation was created to let it honk for ten seconds every ten minutes. 
Since all my other home automations are already using [home assistant](https://www.home-assistant.io) and the S26 switch flashed with [tasmota](https://tasmota.github.io/docs/Getting-Started/). I didn't detail this further.


# Result

So far (two weeks after install), the moles didn't create any new ground constructions in the greater area close to the claxon, I call this a success so far :).

