#!/bin/sh
#########################################################################

# SERVICE SCRIPT CALLED BY OTHER SCRIPTS

currentLogUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')
uid=$(id -u "$currentLogUser")

runAsLogUser() {  
  if [ "$currentLogUser" != "loginwindow" ]; then
    launchctl asuser "$uid" sudo -u "$currentLogUser" "$@"
  else
    echo "No user logged in."
    # uncomment the exit command
    # to make the function exit with an error when no user is logged in
    # exit 1
  fi
}

# UPDATE PURPLE HELPERS
curl -s -L https://prpl.it/helperscript | bash

##-------------------------------##
##       DEPNOTIFY WINDOW        ##
##-------------------------------##

# SET APP TITLE TO APPNAME
echo "$MDMAPPNAME" >> /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname

# SET DEP NOTIFY FOR REINSTALL
curl -s -L https://prpl.it/brandDEPinstall | bash

# START DEPNOTIFY
#sudo -u $(stat -f "%Su" /dev/console) /Library/Application\ Support/Purple/launch-dep.sh &
runAsLogUser /Library/Application\ Support/Purple/launch-dep.sh &
