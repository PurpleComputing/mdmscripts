sed -i -e 's/Quit/Q*uit/' /var/tmp/depnotify.log
sed -i -e 's/Restart/R*estart/' /var/tmp/depnotify.log
bash -c 'osascript -e "tell application \"DEPNotify\"" -e "activate" -e "end tell"'