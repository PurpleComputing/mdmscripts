#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   sonos-s2.sh -- Installs or updates Firefox
#
# SYNOPSIS
#   sudo sonos-s2.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.0
#
#   - 1.0 Joe Farage, 18.03.2015
#
####################################################################################################
# Script to download and install Sonos S2 App.
# Only works on Intel systems.
#

# Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Logs/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/

dmgfile="Sonos.dmg"
logfile="/Library/Caches/com.purplecomputing.mdm/Logs/SonosInstallScript.log"
deplog="/var/tmp/depnotify.log"
scriptver="1.0"

echo "Script Version: ${scriptver}" >> ${logfile}
echo "Status: Installing Sonos S2 App" >> ${deplog}
echo "Status: Installing Sonos S2" >> ${logfile}
url="https://www.sonos.com/redir/controller_software_mac2"

		/usr/bin/curl -L -s -o /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile} ${url}
		/bin/echo "`date`: Mounting installer disk image." >> ${logfile}
		/usr/bin/hdiutil attach /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile} -nobrowse -quiet
		/bin/echo "`date`: Installing..." >> ${logfile}
		ditto -rsrc "/Volumes/Sonos/Sonos.app" "/Applications/Sonos.app"

		/bin/sleep 10
		/bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
		/bin/umount -f /Volumes/Sonos*
		/bin/sleep 10
		/bin/echo "`date`: Deleting disk image." >> ${logfile}
		/bin/rm /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile}

		#double check to see if the new version got updated
			if [[ -e "/usr/local/bin/dockutil" ]]; then  
				/bin/echo "`date`: Creating Dock Icon." >> ${logfile}
				/usr/local/bin/dockutil --remove 'Sonos' --allhomes
				/bin/sleep 3
				/usr/local/bin/dockutil --add '/Applications/Sonos.app' --after 'Safari' --allhomes
			fi
			/bin/echo "--" >> ${logfile}

echo "Command: DeterminateManualStep: 1" >> ${deplog}
exit 0
