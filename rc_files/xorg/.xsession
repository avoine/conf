#!/bin/sh

setxkbmap -layout us -variant altgr-intl
xrdb -merge ~/.Xresources
source ~/.bash_profile
exec exwm
