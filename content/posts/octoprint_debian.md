---
author: "goosst"
date: 2020-07-03
title: Octoprint on debian
tags:
 - octoprint
 - home assistant
 - mail box
 - vl53l0x
 - letter received

---

{{% toc %}}



# Goal

Instead of running octoprint on a raspberry pi, I run it on an old laptop that is lying around here. Below is the code to get video to work. 

# Setup webcam

## Installation of mjpeg streamer

ssh to the device with octoprint installed.

```
sudo apt install git
sudo apt-get install cmake
sudo apt-get install gcc g++
sudo apt-get install libjpeg62-turbo-dev
sudo apt autoremove
git clone https://github.com/jacksonliam/mjpg-streamer.git
cd mjpg-streamer/
cd mjpg-streamer-experimental
make
sudo make install
```

command to startup mjpeg streamer with webcam and make it accessible over http port 8080:
`mjpg_streamer -i "input_uvc.so -d /dev/video0" -o "output_http.so -p 8080 -w /usr/local/www"`


## installation of ffmpeg
easy: `sudo apt install ffmpeg`

To find the path of ffmpeg execute the command `whereis ffmpeg`, you'll need it later in the octoprint settings.

## setup in octoprint

Enter the following settings:
- Stream url: `http://192.168.0.210:8080/?action=stream`
- Snapshot url: `http://192.168.0.210:8080/?action=snapshot`
- Path to FFMPEG: `/usr/bin/ffmpeg` (or whatever `whereis ffmpeg` returned)

Press the test button for each of them to see if it works.
