#!/data/data/com.termux/files/usr/bin/bash

HISTORY_FILE="$HOME/.shortcuts/.song_of_the_day_history"

urlencode() {
  local string="$1" i char out=""
  for (( i=0; i<${#string}; i++ )); do
    char="${string:i:1}"
    case "$char" in
      [a-zA-Z0-9.~_-]) out+="$char" ;;
      *) printf -v hex '%%%02X' "'$char"; out+="$hex" ;;
    esac
  done
  printf '%s' "$out"
}

clip=$(termux-clipboard-get)

case "$clip" in
  https://open.spotify.com/*)
    cleaned="${clip%%\?*}"

    # Phase 1: skip if we've already posted this one
    if [ -f "$HISTORY_FILE" ] && grep -Fxq "$cleaned" "$HISTORY_FILE"; then
      termux-toast "Already posted that song"
      exit 0
    fi

    # Phase 2: record it so future runs track against it
    mkdir -p "$(dirname "$HISTORY_FILE")"
    printf '%s\n' "$cleaned" >> "$HISTORY_FILE"

    post="Unsolicited song of the day: $cleaned"
    encoded=$(urlencode "$post")
    termux-open-url "bluesky://intent/compose?text=$encoded"
    ;;
  *)
    termux-toast "Not a Spotify link"
    ;;
esac
