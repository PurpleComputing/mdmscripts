#!/bin/zsh
# launch-app-installo.sh

# SERVICE SCRIPT CALLED BY OTHER SCRIPTS

# RUNS AS USER
#sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'END'
#export CURL_SSL_BACKEND="secure-transport"

if [ "$EMPTYDOCK" == "Y" ]; then
	echo "Dock will reset"
	/usr/local/bin/dockutil --remove all --allhomes
else
	echo "Dock will not reset"
	echo Continuing...
fi

# CHECKS FOR DIALOG AND PRESENTS IF REQUESTED
if [ "$SHOWDIALOG" == "Y" ]; then
	echo "Dialog will open"
	curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/show-dialog-depnotify.sh?v=123$(date +%s) | bash
else
	echo "Dialog will not open"
	echo Continuing...
fi

	echo "SCRIPT WILL TRY TO ADD TO DOCK"
	curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/add-to-dock.sh?v=123$(date +%s) | bash
	sleep 2
	killall Dock

echo "Command: DeterminateManualStep: 1" >> /var/tmp/depnotify.log

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
echo 
fi
