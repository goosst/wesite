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

{{% toc %}}

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


# Initial temperature test using Home Assistant

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
{{< figure src="/goosst/pictures/heating_on.jpg" title="Python script has set temperature to 21 degrees!" width="450">}}
* do the same for the script `python3 -i set_temperature_off.py`
{{< figure src="/goosst/pictures/heating_off.jpg" title="Python script has set temperature to 15 degrees!" width="450">}}
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

Now this is working, we'll link it to Home Assistant.
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


# Clean up method

In the sections above, we've demonstrated the basic functionallity of controlling the temperature requests. Next steps are:

* to provide the temperature as an argument from Home Assistant to the python script (instead of the hardcoded values from above)
* get rid of seperate python scripts for each function (harder to maintain)
* make sure not multiple people write at the same moment to the ebus (don't want to confuse our system)


## Adapt python scripts

Starting with the python scripts:

* We want to provide the temperature as argument to our python script (have `msg2` as an external input in our script)
* We'll use the `getopt` module in python and parse the arguments to create a temp setpoint, 

```
import getopt

# check if passed options are valid
try:
    options, args = getopt.getopt(sys.argv[1:], 't:',['temperature_setpoint='])
    print(options)
    print(args)
except getopt.GetoptError:
    print("incorrect syntax")
    print("usage: python3 set_temperature.py -t <value>")
    print("default to 12 degrees")
    msg2=12
    sys.exit(2)
for opt, value in options:
    if opt in ('-t','-T','--temperature_setpoint'):
        msg2=value
        print("successful argument")
        print(msg2)
```

  * running the script in commandline becomes: `python3 /home/homeassistant/.homeassistant/python_scripts/set_temperature.py -t 20.5`


## User interface

In `configuration.yaml`, we'll define three input boxes for setting a temperature (night, day and an additional one for instant change of the heating). 
The critical part are the additional `{{}}` arguments in the `shell_command` definition. The exact name of the argument you need to find back in the `states` menu in the user interface.

```

input_number:
  slider1:
    name: Set Now
    initial: 21
    min: 5
    max: 30
    step: 0.25
    unit_of_measurement: "°C"
  slider_night:
    name: Temp Night
    initial: 15
    min: 5
    max: 23
    step: 0.25
    unit_of_measurement: "°C"
  slider_day:
    name: Temp Day
    initial: 21
    min: 5
    max: 25
    step: 0.25
    unit_of_measurement: "°C"

shell_command:
  set_temp_high: 'python3 /home/homeassistant/.homeassistant/python_scripts/set_temperature.py -t {{ states.input_number.slider_day.state }}'
  set_temp_low: 'python3 /home/homeassistant/.homeassistant/python_scripts/set_temperature.py -t {{ states.input_number.slider_night.state }}'
  set_temp_living: 'python3 /home/homeassistant/.homeassistant/python_scripts/set_temperature.py -t {{ states.input_number.slider1.state }}'
```

In `ui-lovelace.yaml`, we'll define a card including our new three sliders.

```
  - title: Verwarming
    cards:
      - type: entities
        title: temperaturen
        entities:
          - sensor.temperature_living
          - sensor.temperature_setpoint_living
          - input_number.slider_day
          - input_number.slider_night
          - input_number.slider1
```

## Mutual exclusion

* We'll be using the python module `ilock` to make sure not multiple instances write/read at the same time to the ebus
* Installation `pi@hassbian:~ $ sudo pip3 install ilock`
  * the `sudo` here turns out to be important: https://community.home-assistant.io/t/shell-command-pi-versus-ha/114939/3

The working code of the pythong script becomes:

```

import subprocess
import time
import getopt
import sys
from ilock import ILock

# check if passed options are valid
try:
    options, args = getopt.getopt(sys.argv[1:], 't:',['temperature_setpoint='])
    print(options)
    print(args)
except getopt.GetoptError:
    print("incorrect syntax")
    print("usage: python3 set_temperature.py -t <value>")
    print("default to 12 degrees")
    msg2=12
    sys.exit(2)
for opt, value in options:
    if opt in ('-t','-T','--temperature_setpoint'):
        msg2=value
        print("successful argument")
        print(msg2)

with ILock('ebus', timeout=200):
	msg1="ebusctl write -c f37 Hc1DayTemp "
	cp = subprocess.run([msg1+msg2],shell=True,stdout=subprocess.PIPE)

	msg1="ebusctl write -c f37 Hc1NightTemp "
	cp = subprocess.run([msg1+msg2],shell=True,stdout=subprocess.PIPE)

	time.sleep(30)

	#check if it is truly set
	cp = subprocess.run(["ebusctl read Hc1DayTemp"],shell=True,stdout=subprocess.PIPE)
	temp=cp.stdout
	if int(float(temp[0:4]))!=int(float(msg2)):
	    # if not set correct
	    msg1="ebusctl write -c f37 Hc1DayTemp "
	    cp = subprocess.run([msg1+msg2],shell=True,stdout=subprocess.PIPE)

	cp = subprocess.run(["ebusctl read Hc1NightTemp"],shell=True,stdout=subprocess.PIPE)
	temp=cp.stdout
	if int(float(temp[0:4]))!=int(float(msg2)):
	    # if not set correct
	    msg1="ebusctl write -c f37 Hc1NightTemp "
	    cp = subprocess.run([msg1+msg2],shell=True,stdout=subprocess.PIPE)
	else:
	    print("setting correct")
```


{{< ama3 >}}

