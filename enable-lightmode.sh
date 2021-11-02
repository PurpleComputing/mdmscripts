#!/bin/bash
#
# if Mosyle preface sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'END'
osascript <<EOD
tell application "System Events"
	tell appearance preferences
		set dark mode to false
	end tell
end tell
EOD