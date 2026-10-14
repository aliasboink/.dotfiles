#!/bin/bash

# Get the current default sink
default_sink=$(pactl get-default-sink)

# Get the index of the current default sink
default_sink_id=$(pactl list sinks short | grep "$default_sink" | awk '{print $1}')

# Get all sink IDs into an array
mapfile -t sink_ids < <(pactl list sinks short | awk '{print $1}')

# Find the index of the current default sink in the array
for i in "${!sink_ids[@]}"; do
    if [[ "${sink_ids[$i]}" == "$default_sink_id" ]]; then
        current_index=$i
        echo "Current index: $current_index"
        break
    fi
done

# Calculate the index of the next sink
if [[ $((current_index + 1)) -ge ${#sink_ids[@]} ]]; then
    next_sink_id=${sink_ids[0]}
    echo "Next ID: $next_sink_id"
else
    next_sink_id=${sink_ids[$((current_index + 1))]}
    echo "Next ID: $next_sink_id"
fi

# Set the next sink as default
pactl set-default-sink "$next_sink_id"

notify-send "Now using: $(pactl get-default-sink)"
