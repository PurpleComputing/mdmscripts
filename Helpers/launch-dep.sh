#bash -c 'osascript -e "tell application \"DEPNotify\"" -e "activate" -e "end tell"'
sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'END'
currentUser=$(id -un)
sudo -u $currentUser open -a /Applications/Utilities/DEPNotify.app --args -fullScreen