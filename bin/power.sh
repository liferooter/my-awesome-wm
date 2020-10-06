#!/usr/bin/env bash

ACTION=$(pkill rofi || rofi -normal-window -dmenu -p "Do" < ~/.config/awesome/bin/power_actions)
case $ACTION in
    "Power off")
        poweroff
        ;;
    "Hibernate")
        systemctl hibernate
        ;;
    "Sleep")
        systemctl suspend
        ;;
    "Lock")
        ~/.config/awesome/bin/lock.sh
        ;;
    "Reboot")
        reboot
        ;;
    "Firmware")
        systemctl reboot --firmware-setup
        ;;
    "Logout")
        loginctl kill-user $USER
        ;;
esac
