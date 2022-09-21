#!/bin/sh
#########################################################################

# SERVICE SCRIPT CALLED BY OTHER SCRIPTS

#
APPNAME=$MDMAPPNAME
INSTALLAPP=googleearth
ILOGO=mosyleb
LOGLOCAL=/Library/Logs/com.purplecomputing.mdm/

# UPDATE PURPLE HELPERS
curl -s -L https://prpl.it/helperscript | bash

##-------------------------------##
##       DEPNOTIFY WINDOW        ##
##-------------------------------##

# SET APP TITLE TO APPNAME
echo "$APPNAME" >> /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname

# SET DEP NOTIFY FOR REINSTALL
curl -s -L https://prpl.it/brandDEPinstall | bash

# START DEPNOTIFY
sudo -u $(stat -f "%Su" /dev/console) /Library/Application\ Support/Purple/launch-dep.sh