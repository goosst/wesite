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

# Convert files in chronological order

```
ls | cat -n | while read n f; do mv "$f" `printf "%04d.jpg" $n`; done
ffmpeg -r 3 -f image2 -start_number 1 -i %04d.jpg -codec:v prores -profile:v 2 output.mov
ffmpeg -i output.mov -filter_complex "[0:v] fps=12,scale=800:-1" schaduw.gif
```
