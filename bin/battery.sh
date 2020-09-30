#!/usr/bin/env bash
BATTERY="BAT0"
BATTERY_PATH="/sys/class/power_supply/${BATTERY}/"
POWER=$(cat ${BATTERY_PATH}/capacity)
STATUS=$(cat ${BATTERY_PATH}/status)

if [[ "$STATUS" == "Charging" ]]
then
    echo -n "⚡"
else
    case $(python -c "print(${POWER} // 10)") in
	0 | 1)
	    echo -n ""
	    ;;
	2 | 3)
	    echo -n ""
	    ;;
	4 | 5)
	    echo -n ""
	    ;;
	6 | 7 | 8)
	    echo -n ""
	    ;;
	*)
	    echo -n ""
	    ;;
    esac
fi
echo "  ${POWER}%     $(xbacklight -get | python -c 'print(int(float(input())))')%   $(sensors | grep 'Core 0' | cut -d" " -f10)"
