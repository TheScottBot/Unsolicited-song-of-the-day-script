#!/data/data/com.termux/files/usr/bin/bash

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
    post="Unsolicited song of the day: $cleaned"
    encoded=$(urlencode "$post")
    termux-open-url "bluesky://intent/compose?text=$encoded"
    ;;
  *)
    termux-toast "Not a Spotify link"
    ;;
esac
