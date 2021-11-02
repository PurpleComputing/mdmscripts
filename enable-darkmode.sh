!/bin/bash
sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'END'
osascript <<EOD
tell application "System Events"
	tell appearance preferences
		set dark mode to true # Can be one of: true, false, not dark
	end tell
end tell
EOD