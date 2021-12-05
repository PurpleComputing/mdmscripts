#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   suitcasefusion.sh -- Installs or updates Firefox
#
# SYNOPSIS
#   sudo suitcasefusion.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.0
#
#   - 1.0 Michael Tanner, 05.12.2021
#
####################################################################################################
# Script to download and install Suitcase Fusion App.
# Only works on Intel systems.
#

# Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Logs/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/

dmgfile="SF.dmg"
logfile="/Library/Caches/com.purplecomputing.mdm/Logs/SuitcaseFusionInstallScript.log"
deplog="/var/tmp/depnotify.log"
scriptver="1.0"

echo "Script Version: ${scriptver}" >> ${logfile}
echo "Status: Installing Suitcase Fusion" >> ${deplog}
echo "Status: Installing Suitcase Fusion" >> ${logfile}
url="https://links.extensis.com/suitcase/sf_latest?language=en&platform=mac"

		/usr/bin/curl -L -s -o /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile} ${url}
		/bin/echo "`date`: Mounting installer disk image." >> ${logfile}
		/usr/bin/hdiutil attach /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile} -nobrowse -quiet
		/bin/echo "`date`: Installing..." >> ${logfile}
		ditto -rsrc "/Volumes/Suitcase Fusion/Suitcase Fusion.app" "/Applications/Suitcase Fusion.app"

		/bin/sleep 10
		/bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
		umount -f /Volumes/Suitcase*
		/bin/sleep 10
		/bin/echo "`date`: Deleting disk image." >> ${logfile}
		/bin/rm /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile}

		#double check to see if the new version got updated
			if [[ -e "/usr/local/bin/dockutil" ]]; then  
				/bin/echo "`date`: Creating Dock Icon." >> ${logfile}
				/usr/local/bin/dockutil --remove 'Suitcase Fusion' --allhomes
				/bin/sleep 3
				/usr/local/bin/dockutil --add '/Applications/Suitcase Fusion.app' --after 'Safari' --allhomes
			fi
			/bin/echo "--" >> ${logfile}

echo "Command: DeterminateManualStep: 1" >> ${deplog}
exit 0
