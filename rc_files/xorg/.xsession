#!/bin/sh

setxkbmap -layout us -variant altgr-intl -option 'caps:super'
xrdb -merge ~/.Xresources
source ~/.bash_profile
exec exwm
