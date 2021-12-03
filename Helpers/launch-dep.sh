#bash -c 'osascript -e "tell application \"DEPNotify\"" -e "activate" -e "end tell"'
currentUser=$(id -un)
sudo -u $currentUser open -a /Applications/Utilities/DEPNotify.app --args -fullScreen