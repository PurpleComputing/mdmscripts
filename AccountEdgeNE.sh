#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   AccountEdgeNE.sh -- Installs or updates AccountEdge Network Edition
#
# SYNOPSIS
#   sudo AccountEdgeNE.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.7
#
#   - 1.0 Martyn Watts, 19.01.2022 Initial Build
#
####################################################################################################
# Script to download and install AccountEdge Network Edition.
#

downloadUrl='https://www.dropbox.com/s/649fftn7q2d4z5n/AENE_r25.1.9.dmg.zip?dl=1'
dnldfile='AENE_r25.19.dmg.zip'
appName='AccountEdge NE'
forceQuit='Y'
logfile="/Library/Caches/com.purplecomputing.mdm/Logs/AccountEdgeNEInstallScript.log"
deplog="/var/tmp/depnotify.log"
OSvers_URL=$( sw_vers -productVersion | sed 's/[.]/_/g' )
userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"
scriptver="1.0"


# Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Logs/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/


/bin/echo "Status: Installing ${appName}" >> ${deplog}
/bin/echo "Status: Installing ${appName}" >> ${logfile}

if [[ $@ == "openconsole" ]]; then
	open ${logfile}
	open ${deplog}
fi

/bin/echo "Script Version: ${scriptver}" >> ${logfile}

        /bin/echo "`date`: Downloading." >> ${logfile}
        /bin/echo "Downloading."
        /usr/bin/curl -L -o /Library/Caches/com.purplecomputing.mdm/Apps/${dnldfile} ${downloadUrl}
        	if [[ "${forceQuit}" = "Y" ]]; then
        		killall ${appName}
        	fi

		cd /Library/Caches/com.purplecomputing.mdm/Apps/
		unzip ${dnldfile}

        /bin/echo "`date`: Mounting installer disk image." >> ${logfile}
       	 /usr/bin/hdiutil attach /Library/Caches/com.purplecomputing.mdm/Apps/${appName}.dmg -nobrowse -quiet
       	 /bin/echo "`date`: Installing..." >> ${logfile}
       	 ditto -rsrc "/Volumes/"${appName}/${appName}".app" "/Applications/"${appName}".app"
       	
       	cd /Library/Caches/com.purplecomputing.mdm/Apps/
       	/usr/sbin/installer -pkg FileConnect.pkg -target /        
        
           
         /bin/sleep 10
       	 /bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
       	 /usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep AppName | awk '{print $1}') -quiet
       	 /bin/sleep 10
       

       	/bin/sleep 5
        /bin/echo "`date`: Deleting the downloaded file." >> ${logfile}
        /bin/rm /Library/Caches/com.purplecomputing.mdm/Apps/${dnldfile}

    /bin/echo "Command: DeterminateManualStep: 1" >> ${deplog}

