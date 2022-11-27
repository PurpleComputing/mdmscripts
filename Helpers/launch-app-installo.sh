#!/bin/zsh
# launch-app-installo.sh

# SERVICE SCRIPT CALLED BY OTHER SCRIPTS

# INSTALLS APPLICATION
sleep 5
curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/install-app-loop-beta.sh?v=123$(date +%s) | bash

# CHECKS TO ADD TO DOCK OR NOT
if [ "$MDMADDTODOCK" == "Y" ]; then
	echo "SCRIPT WILL TRY TO ADD TO DOCK"
	curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/add-to-dock.sh?v=123$(date +%s) | bash
	sleep 2
	killall Dock
else
	echo "SCRIPT WILL NOT TRY TO ADD TO DOCK"
	echo Continuing...
fi
