#!/data/data/com.termux/files/usr/bin/bash

clip=$(termux-clipboard-get)

case "$clip" in
  https://open.spotify.com/*)
    cleaned="${clip%%\?*}"
    termux-clipboard-set "Unsolicited song of the day: $cleaned"
    termux-toast "Spotify link cleaned ✓"
    ;;
  *)
    termux-toast "Not a Spotify link"
    ;;
esac
