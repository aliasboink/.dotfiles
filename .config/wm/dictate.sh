#!/usr/bin/env bash
# Push-to-talk dictation with whisper.cpp. First press starts recording,
# second press transcribes and types the text into the focused window.
set -u

STATE="${XDG_RUNTIME_DIR:-/tmp}/dictate"
PIDFILE="$STATE.pid"
WAV="$STATE.wav"
CLI="$HOME/whisper.cpp/build/bin/whisper-cli"
MODEL="$HOME/whisper.cpp/models/ggml-base.en.bin"

# Replaces the previous dictate notification instead of stacking them
notify() {
  notify-send -a dictate -t 2000 \
    -h string:x-canonical-private-synchronous:dictate "$@" 2>/dev/null
}

type_text() {
  if [ "${XDG_SESSION_TYPE:-}" = wayland ]; then
    wtype -- "$1"
  else
    xdotool type --delay 1 -- "$1"
  fi
}

pid=$(cat "$PIDFILE" 2>/dev/null)
if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
  # Second press: stop recording and wait for arecord to finish the file
  kill -INT "$pid"
  while kill -0 "$pid" 2>/dev/null; do sleep 0.05; done
  rm -f "$PIDFILE"
  notify "Transcribing…"

  # Drop whisper's non-speech tags like [BLANK_AUDIO] or (music)
  text=$("$CLI" -m "$MODEL" -f "$WAV" -t 8 -nt -np 2>/dev/null \
    | sed -E 's/\[[^]]*\]//g; s/\([^)]*\)//g' \
    | tr '\n' ' ' | tr -s ' ' | sed -E 's/^ //; s/ $//')
  rm -f "$WAV"

  if [ -n "$text" ]; then
    notify -t 1 "Done"
    type_text "$text"
  else
    notify "Nothing heard"
  fi
else
  # First press: record 16 kHz mono, the format whisper.cpp expects
  arecord -q -f S16_LE -r 16000 -c 1 "$WAV" &
  echo $! > "$PIDFILE"
  notify "Recording… press Super+T to stop"
fi
