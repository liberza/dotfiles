#!/bin/bash
function dp_activate {
	echo "Monitor connected, placing above as primary"
	xrandr --output DP1 --mode 2560x1440 --rate 60.0 --primary
	xrandr --output LVDS1 --mode 1366x768 --pos 526x1440 --rate 60.0
	MONITOR=DP1
}

function dp_deactivate {
	echo "Monitor disconnected."
	xrandr --output LVDS1 --mode 1366x768 --rate 60.0 --pos 0x0
	MONITOR=LVDS1
}

renice +19 $$ >/dev/null
OLD_DUAL="dummy"

while true; do
	DUAL=$(cat /sys/class/drm/card0-DP-1/status)

	if [[ $OLD_DUAL != $DUAL ]]; then
		if [[ $DUAL == "connected" ]]; then
			dp_activate
		else
			dp_deactivate
		fi
		OLD_DUAL="$DUAL"
	fi

	sleep 1
done
