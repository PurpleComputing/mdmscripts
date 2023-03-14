#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   zacphone.sh -- Installs or updates Firefox
#
# SYNOPSIS
#   sudo zacphone.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.0
#
#   - 1.0 Michael Tanner, 14.03.2023
#
####################################################################################################
# Script to download and install Zac Phone App.
#

# Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Logs/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/

dmgfile="zac.dmg"
logfile="/Library/Caches/com.purplecomputing.mdm/Logs/zacphoneInstallScript.log"
deplog="/var/tmp/depnotify.log"
scriptver="1.0"

echo "Script Version: ${scriptver}" >> ${logfile}
echo "Status: Installing Zac Phone" >> ${deplog}
echo "Status: Installing Zac Phone" >> ${logfile}
url=$(/usr/bin/curl -s -A "$userAgent" https://www.zultys.com/zac-download/ | grep 'window.location' | sed -e 's/.* window.location="\(.*\)".*/\1/' -e 's/\"//' | /usr/bin/awk '{print $1}'| tail -n 1)

		/usr/bin/curl -L -o /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile} ${url}
		cp /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile} /Library/Caches/com.purplecomputing.mdm/Apps/a${dmgfile}
		/bin/echo "`date`: Mounting installer disk image." >> ${logfile}
		/usr/bin/hdiutil attach /Library/Caches/com.purplecomputing.mdm/Apps/a${dmgfile} -nobrowse -quiet
		/bin/echo "`date`: Installing..." >> ${logfile}
		cd "/Volumes/zac_*"
		ditto -rsrc "zac.app" "/Applications/zac.app"

		/bin/sleep 10
		/bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
		umount -f /Volumes/zac*
		/bin/sleep 10
		/bin/echo "`date`: Deleting disk image." >> ${logfile}
		/bin/rm /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile} /Library/Caches/com.purplecomputing.mdm/Apps/a${dmgfile}

		#double check to see if the new version got updated
			if [[ -e "/usr/local/bin/dockutil" ]]; then  
				/bin/echo "`date`: Creating Dock Icon." >> ${logfile}
				/usr/local/bin/dockutil --remove 'zac' --allhomes
				/bin/sleep 3
				/usr/local/bin/dockutil --add '/Applications/zac.app' --after 'Safari' --allhomes
			fi
			/bin/echo "--" >> ${logfile}

echo "Command: DeterminateManualStep: 1" >> ${deplog}
exit 0
