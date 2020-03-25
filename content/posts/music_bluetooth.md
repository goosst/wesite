---
author: "goosst"
date: 2020-02-18
title: Bluetooth speaker
tags:
 - tinkberboard
 - armbian
 - debian
 - bluetooth
 - home assistant
---

{{% toc %}}

# Intro


# Bluetooth connection

* sudo apt-get install vlc
* `pip3 install sh`
```
from sh import bluetoothctl
import subprocess

bluetoothctl("connect", "94:E3:6D:61:59:72")
```

```
cp = subprocess.run(["cvlc --no-video /home/stijn/test.mp3"],shell=True,stdout=subprocess.PIPE)
```
