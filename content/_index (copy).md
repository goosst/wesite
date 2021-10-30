+++
title = "Goosst blog"
date = "2019-07-31"
+++

- stlink setup https://github.com/stlink-org/stlink/blob/develop/doc/tutorial.md


```
 2006  sudo apt-get install stlink-tools
 2008  st-info --version
 2009  st-info --probe
 2010  sudo st-info --probe
 2014  ls -l /dev/bus/usb/002/011
 2015  cd /etc/udev
 2016  ls -la
 2017  cd rules.d
 2018  ls -la
 2030  sudo wget https://raw.githubusercontent.com/stlink-org/stlink/develop/config/udev/rules.d/49-stlinkv1.rules
 2032  sudo wget https://raw.githubusercontent.com/stlink-org/stlink/develop/config/udev/rules.d/49-stlinkv2-1.rules
 2034  sudo wget https://raw.githubusercontent.com/stlink-org/stlink/develop/config/udev/rules.d/49-stlinkv2.rules
 2035  ls -la
 2036  sudo wget https://raw.githubusercontent.com/stlink-org/stlink/develop/config/udev/rules.d/49-stlinkv3.rules
 2037  sudo udevadm control --reload-rules
 2038  sudo udevadm trigger
```
