#!/bin/zsh
# launch-app-installo.sh

# SERVICE SCRIPT CALLED BY OTHER SCRIPTS

# RUNS AS USER
sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'END'


cd /Library/Application\ Support/Purple/

# CHECKS FOR DIALOG AND PRESENTS IF REQUESTED
if [ "$SHOWDIALOG" == "Y" ]; then
	echo "Dialog will open"
	curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/show-dialog-depnotify.sh | bash
else
	echo "Dialog will not open"
	echo Continuing...
fi

# INSTALLS APPLICATION
sleep 5
curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/install-app-loop.sh | bash

# CHECKS TO ADD TO DOCK OR NOT
if [ "$MDMADDTODOCK" == "Y" ]; then
	echo "SCRIPT WILL TRY TO ADD TO DOCK"
	curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/add-to-dock.sh | bash
	sleep 2
	killall Dock
else
	echo "SCRIPT WILL NOT TRY TO ADD TO DOCK"
	echo Continuing...
fi


if [ "$SHOWDIALOG" == "Y" ]; then
	# MOVES DEPNOTIFY STATUS BAR
	echo Command: MainTitle: Installed "$MDMAPPNAME" >> /var/tmp/depnotify.log
	echo 'Command: Image: /Library/Application Support/Purple/logo.png' >> /var/tmp/depnotify.log
	echo Command: MainText: "The install or update for $MDMAPPNAME has finished". >> /var/tmp/depnotify.log
	
	echo "Command: DeterminateManualStep: 1" >> /var/tmp/depnotify.log
	
	echo 'Command: WindowStyle: Activate' >> /var/tmp/depnotify.log
	echo 'Command: ContinueButton: Finish' >> /var/tmp/depnotify.log
	echo "Status: Installed or Updated $MDMAPPNAME, click Finish!" >> /var/tmp/depnotify.log
else
	echo "Final message will not send"
	echo Continuing...
fi

unset MDMAPPNAME MDMAPPLABEL MDMADDTODOCK SHOWDIALOG