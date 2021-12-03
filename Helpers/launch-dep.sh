#bash -c 'osascript -e "tell application \"DEPNotify\"" -e "activate" -e "end tell"'
loggedInUserID=$(id -u $loggedInUser)
launchctl asuser $loggedInUserID open -a /Library/Application\ Support/truEndpoint/DEPNotify.app --args -fullScreen