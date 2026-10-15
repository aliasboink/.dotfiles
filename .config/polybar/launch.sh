#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit >/dev/null 2>&1
# Otherwise you can use the nuclear option:
# killall -q polybar

# Wait until the old bars have exited, so a quick reload doesn't leave duplicates.
# A bar that is still starting up misses the IPC quit, so fall back to a signal.
for i in $(seq 20); do pgrep -u "$UID" -x polybar >/dev/null || break; sleep 0.1; done
killall -q polybar
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 0.1; done

# Battery and AC adapter names differ between machines; a desktop has neither.
for ps in /sys/class/power_supply/*; do
  case "$(cat "$ps/type" 2>/dev/null)" in
    Battery) [ -z "$BATTERY" ] && export BATTERY="${ps##*/}" ;;
    Mains) [ -z "$ADAPTER" ] && export ADAPTER="${ps##*/}" ;;
  esac
done
if [ -z "$BATTERY" ]; then
  export MODULES_RIGHT="$(polybar --dump=modules-right example 2>/dev/null | sed 's/ battery\b//')"
fi

if command -v xrandr >/dev/null; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example 2>&1 | tee -a /tmp/polybar1.log & disown
  done
else
  polybar --reload example 2>&1 | tee -a /tmp/polybar1.log & disown
fi
