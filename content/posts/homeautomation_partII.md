---
author: "goosst"
date: 2019-04-20
title: Heating automation - set temperatures
tags:
 - vaillant
 - ecotec plus
 - ebus
 - home assistant
 - raspberry pi
---

# Intro
In this part we'll:

* install hassbian
* set our requested room temperature through the interface of Home Assistant. 


# Preparing the Raspberry pi

There is hassbian, hass.io, homme-assistant itself, ... as you see, not confusing at all :). I'm using hassbian since at least I know ebusd works in a debian environment on the raspberry pi. I'm not familiar with docker (hass.io) and its limitations.

* Follow the Hassbian installation instructions: https://www.home-assistant.io/docs/installation/hassbian/installation/
* find your ip-address and have ssh enabled (plenty of sites which explain this)
* Additional installations beside the normal updating, upgrading, setting the time-zone: 

```
sudo apt-get install net-tools nmap
sudo hassbian-config install mosquitto
sudo hassbian-config install samba
```
An overview of other helper scripts can be found at: https://github.com/home-assistant/hassbian-scripts


# Home Assistant

It's time to get our heater commanded through Home Assistant.
In general it's good to:

* read a few intro's on Home Assistant before you jump in to it
* get Samba up and running so you can edit your home assistant files from your standard working computer (again enough other tutorials can be found)

## Concept

We'll be using python scripts to trigger actions from Home Assistant to ebus(d).
In this way we can focus on making all the ebus related items running in python and we don't have to deal with the custom Home Assistant syntax. I personally prefer spending time learning python over learning a custom program specific language/syntax. 


## python scripts
We'll create a few python scripts to test if we can control our heater from python. On the Pi we will create a new folder `python_scripts` locate the scripts in `/home/homeassistant/.homeassistant/python_scripts`.

* The script below with the name `set_temperature_on.py` will set the day and night temperatures to 21C by calling the appropriate ebus commands directly from the command line (making use of the subprocess function). The second part of the script just does an additional check if it was really set correctly. 
* create the same script with the name `set_temperature_off.py` where `msg2` in the script below has been changed to `msg2=15`. (Yes, I know this is a stupid way of working and we should give the temperature as an argument to the python script. But for initial testing/debugging this is good enough.)

```
import subprocess
import time

msg2="21" #setpoint temperature degrees celsius

msg1="ebusctl write -c f37 Hc1DayTemp "
cp = subprocess.run([msg1+msg2],shell=True,stdout=subprocess.PIPE)

msg1="ebusctl write -c f37 Hc1NightTemp "
cp = subprocess.run([msg1+msg2],shell=True,stdout=subprocess.PIPE)

#redundancy check if it is truly set
time.sleep(60)

cp = subprocess.run(["ebusctl read Hc1DayTemp"],shell=True,stdout=subprocess.PIPE)
temp=cp.stdout
if int(float(temp[0:4]))!=int(msg2):
    # if not set correct
    msg1="ebusctl write -c f37 Hc1DayTemp "
    cp = subprocess.run([msg1+msg2],shell=True,stdout=subprocess.PIPE)


cp = subprocess.run(["ebusctl read Hc1NightTemp"],shell=True,stdout=subprocess.PIPE)
temp=cp.stdout
if int(float(temp[0:4]))!=int(msg2):
    # if not set correct
    msg1="ebusctl write -c f37 Hc1NightTemp "
    cp = subprocess.run([msg1+msg2],shell=True,stdout=subprocess.PIPE)
else:
    print("setting correct")
```

* check if the scripts are really working by running the command from the raspberry pi terminal `python3 -i set_temperature_on.py`
 * as an additional check, on the thermostat you will see the temperature setting change
{{< figure src="/goosst/pictures/heating_on.jpg" title="Python script has set temperature to 21 degrees!" width="250">}}
* do the same for the script `python3 -i set_temperature_off.py`
{{< figure src="/goosst/pictures/heating_off.jpg" title="Python script has set temperature to 15 degrees!" width="250">}}
Output in the terminal of the raspberry:

```
pi@hassbian:/home/homeassistant/.homeassistant/python_scripts $ python3 -i set_temperature_on.py 
setting correct
>>> quit()
pi@hassbian:/home/homeassistant/.homeassistant/python_scripts $ python3 -i set_temperature_off.py 
setting correct
>>> 

```

## Home Assistant services

If you've followed Home Assistant intro's, you know all magic happens in the `configuration.yaml` file(s).
We'll be using the `shell_command` component which basically just executes a script in the terminal / command line of the raspberry.
Add the following into `configuration.yaml` and reload/reboot home assistant.

```
shell_command:
  set_temp_high: python3 /home/homeassistant/.homeassistant/python_scripts/set_temperature_on.py
  set_temp_low: python3 /home/homeassistant/.homeassistant/python_scripts/set_temperature_off.py
```

From the Home Assistant interface:

* click on the services button in "Developer tools"
* check the shell_command services
* if you select the `set_temp_low` and `set_temp_high` and press "call service" the temperature will be set to 15 and 21 degrees :)

{{< figure src="/goosst/pictures/HA_services2.png" title="Service becomes available in Home Assistant" width="500">}}


## Next steps

Next steps will be to:

* provide the temperature as an argument form Home Assistant to the python script instead of having hardcoded values
* make it part of automation routines


{{< ama1 >}}

