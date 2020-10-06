#!/usr/bin/env bash
acpi_listen | \
    while read POWER
    do
        if [[ "$(echo $POWER | cut -d" " -f1-2)" = "button/power PBTN" ]]
        then
            ~/.config/awesome/bin/power.sh
        fi
    done
