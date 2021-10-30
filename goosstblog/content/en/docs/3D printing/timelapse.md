---
author: "goosst"
date: 2020-02-18
title: Time laps
tags:
 - raspberry pi
 - MotionEyeOs
---

{{% toc %}}

# Goal

Create timelaps of captured images

# MotioneyeOs

Capture images by installing on a raspberry `https://github.com/ccrisan/motioneyeos`

# Convert files in chronological order
Glue files together to an animated gif:
- by renaming them in chronological order (using linux command)
- by using ffmpeg to convert into a movie and animated gif

```
ls | cat -n | while read n f; do mv "$f" `printf "%04d.jpg" $n`; done
ffmpeg -r 3 -f image2 -start_number 1 -i %04d.jpg -codec:v prores -profile:v 2 output.mov
ffmpeg -i output.mov -filter_complex "[0:v] fps=12,scale=800:-1" schaduw.gif
```
