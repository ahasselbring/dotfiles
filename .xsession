#!/bin/bash

xinput set-prop "SynPS/2 Synaptics TouchPad" "Device Enabled" 0
urxvtd -q -o -f
xscreensaver -no-splash &
xset s 0
xset dpms 0 0 1800
xbacklight -set 50
exec awesome
