# Spotify Link Cleaner Widget

A one-tap Termux:Widget that takes a Spotify link from your clipboard, strips the
`?si=...` tracking parameter, and puts it back wrapped as
`Unsolicited song of the day: {link}`.

## Requirements

- [Termux](https://github.com/termux/termux-app)
- [Termux:API](https://github.com/termux/termux-api) (app + `pkg install termux-api`)
- [Termux:Widget](https://github.com/termux/termux-widget)

> Install all three from the **same source** (F-Droid *or* GitHub releases). Builds
> from different sources are signed differently and won't talk to each other.

## Setup

### 1. Create the script

Termux:Widget only reads scripts from `~/.shortcuts`.

```bash
mkdir -p ~/.shortcuts
nano ~/.shortcuts/clean-spotify.sh
```

Paste in:

```bash
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
```

Optionally use [bsky-draft.sh](https://github.com/FtrOnOff/Unsolicited-song-of-the-day-script/blob/main/bsky-draft.sh)
for even less work; it strips the link and opens the Bluesky composer with the post
prefilled, so you just tap to send.

### 2. Make it executable

```bash
chmod +x ~/.shortcuts/clean-spotify.sh
```

### 3. Add the widget

Long-press your home screen, add the **Termux:Widget**, then tap
`clean-spotify.sh` in the list. It's one tap from then on.

## How it works

- `${clip%%\?*}` is bash parameter expansion that chops everything from the first
  `?` onward, so `...2DZaj1Qemb4HNXyXDQmCG7?si=61UW...` becomes
  `...2DZaj1Qemb4HNXyXDQmCG7`. No regex or `sed` needed.
- The `case` guard means the clipboard is only touched when its contents start with
  `https://open.spotify.com/`. Anything else just gets a "Not a Spotify link" toast
  and the clipboard is left alone.

Drop the `termux-toast` lines if you'd rather it run silently.
