#!/bin/sh

setxkbmap -layout us -variant altgr-intl
xrdb -merge ~/.Xresources
exec exwm
