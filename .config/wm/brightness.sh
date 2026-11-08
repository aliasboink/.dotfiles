#!/bin/sh
# Change screen brightness by a step: brightness.sh up|down [step]
#
# Laptops use the panel backlight (brightnessctl). Desktops with only an
# external monitor have no backlight, so talk to the monitor over DDC/CI
# (ddcutil; needs the i2c group and the i2c-dev module).

step=${2:-5}
case $1 in
    up) sign=+ ;;
    down) sign=- ;;
    *) echo "usage: $0 up|down [step]" >&2; exit 1 ;;
esac

if ls /sys/class/backlight/* >/dev/null 2>&1; then
    exec brightnessctl -q set "$step%$sign"
fi

# Held keys repeat ~25 times a second, faster than DDC can keep up with.
# Skip presses that arrive while a change is still running, so the monitor
# stops changing as soon as the key is let go.
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/brightness.lock"
flock -n 9 || exit 0

# "VCP 10 C <current> <max>"
set -- $(ddcutil getvcp 10 --brief) || exit 1
cur=$4 max=$5
new=$((cur $sign step))
[ "$new" -lt 0 ] && new=0
[ "$new" -gt "$max" ] && new=$max
[ "$new" -ne "$cur" ] && ddcutil setvcp 10 "$new" --noverify
