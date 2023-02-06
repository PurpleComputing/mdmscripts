#!/bin/zsh
# launch-app-installo.sh

# SERVICE SCRIPT CALLED BY OTHER SCRIPTS

currentUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')
uid=$(id -u "$currentUser")

runAsUser() {  
  if [ "$currentUser" != "loginwindow" ]; then
    launchctl asuser "$uid" sudo -u "$currentUser" "$@"
  else
    echo "No user logged in."
    # uncomment the exit command
    # to make the function exit with an error when no user is logged in
    # exit 1
  fi
}

if [ "$EMPTYDOCK" == "Y" ]; then
	if [ "$ASUSER" == "Y" ]; then
	runAsUser /usr/local/bin/dockutil --remove all --homeloc /Users/$(stat -f "%Su" /dev/console)/
else
	/usr/local/bin/dockutil --remove all --allhomes
fi
else
	echo "Dock will not reset"
	echo Continuing...
fi

# CHECKS FOR DIALOG AND PRESENTS IF REQUESTED
if [ "$SHOWDIALOG" == "Y" ]; then
	echo "Dialog will open"
	curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/show-dialog-depnotify.sh?v=123$(date +%s) | bash
	echo Command: MainTitle: Changing Your Dock >> /var/tmp/depnotify.log
	echo Command: MainText: We are updating your Dock with your applications. >> /var/tmp/depnotify.log
	echo Command: WindowStyle: Activate >> /var/tmp/depnotify.log
else
	echo "Dialog will not open"
	echo Continuing...
fi

if [ "$ASUSER" == "Y" ]; then
	echo "SCRIPT WILL TRY TO ADD TO DOCK AS USER"
	curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/add-to-dock-as-user.sh?v=123$(date +%s) | bash
	sleep 2
	killall Dock
else
	echo "SCRIPT WILL TRY TO ADD TO DOCK FOR ALL HOMES"
	curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/add-to-dock.sh?v=123$(date +%s) | bash
	sleep 2
	killall Dock
fi



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
