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

dmgfile="DetectX_Swift.app.zip"
logfile="/Library/Caches/com.purplecomputing.mdm/Logs/SuitcaseFusionInstallScript.log"
deplog="/var/tmp/depnotify.log"
scriptver="1.0"

echo "Script Version: ${scriptver}" >> ${logfile}
echo "Status: Installing Suitcase Fusion" >> ${deplog}
echo "Status: Installing Suitcase Fusion" >> ${logfile}
url="https://s3.amazonaws.com/sqwarq.com/PublicZips/DetectX_Swift.app.zip"
cd /Library/Caches/com.purplecomputing.mdm/Apps/
		/usr/bin/curl -L -s -o /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile} ${url}
    unzip DetectX_Swift.app.zip
		/bin/echo "`date`: Installing..." >> ${logfile}
		ditto -rsrc "/Library/Caches/com.purplecomputing.mdm/Apps/DetectX Swift.app" "/Applications/DetectX Swift.app"

		/bin/sleep 10
		/bin/rm /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile}
echo "Command: DeterminateManualStep: 1" >> ${deplog}
exit 0
