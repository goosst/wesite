---
author: "goosst"
date: 2019-11-10
title: Remote access home assistant
tags:
 - crunchbang plus plus
 - armbian
 - debian
 - tor
 - home assistant
 - torrc
 - Orbot
 - Orfox
 - home automation
---

{{% toc %}}

# Intro
Don't we all want to monitor our home remotely (i.e. when not connected to our local network), turn on the heating on or off if we change our plans, check if everything is going well with our created home automation, etc.
Of course we want to do this in a secure way that has limited chance of being hacked.

In this section we'll use tor to access home assistant remotely and connect to it from our mobile phone (through mobile internet).
Read more about [Tor Hidden Services](https://2019.www.torproject.org/docs/onion-services).

# Installation
I'm using a debian based system with home assistant running in a virtual (python) environment, as described [here]({{< ref "hass_laptop.md" >}}).

The documentation to setup tor is here: [homeassistant tor](https://www.home-assistant.io/docs/ecosystem/tor).
However, for debian 10 (buster), this isn't entirely correct anymore.
The 'HiddenServiceVersion 2', needs to be added to the torrc configration. All the other steps are still relevant.

torrc:
```
HiddenServiceDir /var/lib/tor/homeassistant
HiddenServicePort 80 127.0.0.1:8123
HiddenServiceVersion 2
HiddenServiceAuthorizeClient stealth haremote1
```

# Accessing from Android phone
As described in [homeassistant tor](https://www.home-assistant.io/docs/ecosystem/tor), one need to install Orbot and Orfox (Tor browser).

## Configuring Orbot

* Use the result obtained by executing `$ sudo more /var/lib/tor/homeassistant/hostname`, you will obtain something like `xxxxx.onion xx....xx`.
* Edit the torrc file in Orbot --> Settings --> Torrc Custom Config. Fill in: `HidServAuth xxxxx.onion xx....xx`
* One additional step I had to, is to go to Orbot --> Settings --> Tor SOCKS and add port 9150. This to avoid getting a refused connection because of proxy servers.

# Home Assistant
The `configuration.yaml` file should have `type: homeassistant` to be able to access it remotely.
In my case when connected from the local internet (not through tor), I'm automatically logged in.

```
auth_providers:
  - type: trusted_networks
    trusted_networks:
      - 192.168.0.0/24
    allow_bypass_login: true
  - type: homeassistant
```

# Usage

## Orfox / Tor Browser

* Start up Orbot (by pressing Start)
* If successful, start up the Tor Browser and browse to your xxxxx.onion address. You should see your homeassistant login screen.
* Create a bookmark with your .onion address. It's hard to know it by hard :).
* click "Home Assistant Local"
* type in your home assistant username and password
* and you have your usual interface screen :)

## Create a macro

Of course we are all lazy and don't want to start up Orbot, launch the browser, login to homeassistant, and change our settings.
Here is an example on how to create a macro on an android phone to turn on your heating: [link]({{< ref "hass_tor_macro.md" >}}).
