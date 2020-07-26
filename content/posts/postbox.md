---
author: "goosst"
date: 2020-04-19
title: Mail detection
tags:
 - wemos d1 mini
 - home assistant
 - mail box
 - vl53l0x
 - letter received

---

{{% toc %}}

# Goal

Monitor when a letter / package is dropped in your mail box (the real mail, not e-mail).

# Hardware
- VL53L0X sensor, measures the distance accurately according the time-of-flight principle
- wemos D1 mini, to connect to wifi (and send an mqtt message)
- Batteries (two AA's in my case)
- MT3608: step up DC-DC to generate supply for wemos

This is how it looks and gets positioned at the bottom of my post box (yes, there is room for improvement). The backside is too crappy to be published on the internet ;).
{{< figure src="/goosst/pictures/mailbox2.jpg" title="Top (VL53L0X pointing upwards)" width="400">}}

# Tasmota

## Generate .bin files
Tasmota will be used as software on the wemos, since it has all the needed features (mqtt support, deep sleep to reduce power consumption, latest firmware updates for ESP, ...).

The VL53L0X sensor is not included in the default releases, meaning a custom build has to be made (cfr. https://tasmota.github.io/docs/Builds/).
The steps are explained on the documentation site of Tasmota (https://tasmota.github.io/docs/Create-your-own-Firmware-Build-without-IDE/), but as a summary:

- Install platformio and download the tasmota source, this was done on a linux system:
```
virtualenv platformio-core
cd platformio-core
. bin/activate
pip install -U platformio
pip install --upgrade pip
git clone https://github.com/arendst/Tasmota.git (or whichever fork you've created)
cd Tasmota/
platformio platform update
```
- Edit `my_user_config.h` by uncommenting `#define USE_VL53L0X` in the file.
- Build tasmota by executing: `time pio run 2>&1 | tee build.log`
- Wait till the build has finished and find the generated file: `.pioenvs/tasmota/firmware.bin`
Important remark: in case important Tasmota updates get released (e.g. security related), you will have to repeat these steps.


This generated file has to be flashed, I use Tasmota Pyflasher on Windows to do so (ubuntu gives me problems to reliably flash).


## Configuration

Steps:

- Tasmota will create it's own Wifi network, connect to it
- A browser will popup to configure the wireless network the ESP/wemos should connect to
- Browse to the ip address of the new device on your network
- Choose `Generic` as module type
- Configure D1 and D2 to be respectively SCL and SDA (the deepsleep and D8 will come later)
{{< figure src="/goosst/pictures/Tasmota2.png" title="Tasmota setup" width="450">}}
- The sensor and its reading appear :)
{{< figure src="/goosst/pictures/tasmota3.png" title="Tasmota setup" width="450">}}
- configuring MQTT is rather self-explaining
- check in the console window of tasmota what messages are getting broadcasted
- I enter a `Restart 1` in the console to make sure settings are saved (not sure if this is needed)

# Extending battery life

To avoid changing batteries constantly, the idle power consumption should be minimized.
Reduction will be done in the two main components:

-  ESP8266 by using deep sleep
-  VL53L0X by using the Xshut pin

## Tasmota - Deepsleep

To extend battery life, deep sleep is used (see https://tasmota.github.io/docs/DeepSleep/).

- Connect RST pin to D0 (GPIO16)
- Browse to ip-address of tasmota
- Set TelePeriod to a number higher than 10, e.g. `TelePeriod 50` (the duration it will stay awake after every deepsleep cycle)
- Set `DeepSleepTime 3600` (or whichever duration you want to let it sleep)


## VL53L0X

The pin Xshut is used to enable/disable the sensor, there is an issue however:

- The Xshut pin should be pulled low during our deepsleep to disable the sensor. The only pin which has this behaviour is D8/GPIO15: https://tasmota.github.io/docs/DeepSleep/#esp8266-deep-sleep-side-effects.
- Xshut is active low, so it will try to pull pin D8 high. The big issue here is, GPIO15 should be low during the boot of the ESP8266 or the module will not boot up ... .

Solution:

- Connect Xshut to D8
- add an additional pull down resistor to Xshut and GND (here using 2k ohm).
{{< figure src="/goosst/pictures/VL53Pulldown.jpg" title="Additional resistor" width="250">}}
- In Tasmota:
  - make sure pin D8 is configured as a Relay
  - `PowerOnState 1`, so D8 gets switched on at a restart of the ESP8266

Now pin Xshut is low during Deepsleep and high when the ESP is awake!

## Wemos power supply

To avoid unnecessary power losses, the wemos is directly fed to its 3.3V pin and not through the regular 5V (see the schematic of the Wemos mini).

# Home Assistant

Now get this information in home assistant (easier to test this before starting to use deepsleep ... ):

Create a sensor in `configuration.yaml`, get the exact mqtt message from the console window in Tasmota.
```
sensor:
  - platform: mqtt
    name: "MailBox"
    state_topic: tele/MailBox/SENSOR
    value_template: "{{ value_json['VL53L0X'].Distance }}"
    expire_after: 7200
    unit_of_measurement: "mm"
    availability_topic: "tele/MailBox/LWT"
    payload_available: "Online"
    payload_not_available: "Mailbox sensor Offline"
```

Instead of the raw distance measurement it should get converted to an indication if we have new post or not.
This could be done in Tasmota as well by using Rules (https://tasmota.github.io/docs/Rules/), but I prefer to keep calculations central.

To be fair, I personally dislike this - yet again a new syntax -  `value templating` in home assistant a lot and try to avoid it wherever I can.
Unfortunately, there isn't a real way to get around it unless having a trigger on mqtt messages (but using the same information on multiple location isn't really considered good programming either).

So the automation triggers a python script `mailboxstate.py` everytime the mailbox sensor gets updated:
```
automation MailBox:
  - alias: MailBox
    trigger:
      platform: template
      value_template: "{{ (states.sensor.date_time.last_changed - states.sensor.mailbox.last_updated).total_seconds() > 30 }}"
    action:
      service: shell_command.mailboxstate
```

mailboxstate.py uses the REST api to read the mailbox sensor, and write the converted state of the mailbox to a new variable (`mailboxfull`).
The full script is available at: https://github.com/goosst/HomeAutomation/blob/master/python_scripts/mailboxstate.py, but it will report the following states:

```
if time_last>now-max_delay:
    #Check if empty (comparison in mm)
    if state_last<100:
        payload='{"state": "Check you post box!"}'
    elif state_last>=100 and state_last<1200:
        payload='{"state": "Post box is empty"}'
    else:
        payload='{"state": "No clue"}'
else:
    payload='{"state": "No update"}'
```

# Result

Adding both entities in ui-lovelace results in something like this:
{{< figure src="/goosst/pictures/mailbox_hass2.png" title="Tasmota setup" width="400">}}
{{< figure src="/goosst/pictures/mailbox_hass.png" title="Tasmota setup" width="400">}}
