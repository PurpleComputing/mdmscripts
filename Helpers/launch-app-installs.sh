#!/bin/sh

# Installation using Installomator with Dialog showing progress (and possibility of adding to the Dock)
echo "*** USING BETA SCRIPT: LAUNCH ***"

curl -s "https://raw.githubusercontent.com/Installomator/Installomator/main/MDM/install%20swiftDialog%20direct.sh" | bash
curl -s "https://raw.githubusercontent.com/Installomator/Installomator/main/MDM/install%20Installomator%20direct.sh" | bash

whatList="$MDMAPPLABEL"

for what in $whatList; do
export what
echo Installing ${what}
	curl -s "https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/install-app-loop-beta-multiple.sh?v=123$(date +%s)" | bash
done


if [ "$MDMADDTODOCK" == "Y" ]; then
    echo "SCRIPT WILL TRY TO ADD TO DOCK"
    curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/add-to-dock.sh?v=123$(date +%s) | bash
    sleep 2
    killall Dock
else
    echo "SCRIPT WILL NOT TRY TO ADD TO DOCK"
    echo Continuing...
fi
