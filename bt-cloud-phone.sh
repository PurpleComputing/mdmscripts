#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   BT Cloud Phone Installer Updater.sh -- Installs or updates BT CLoud Phone
#
# SYNOPSIS
#   sudo BTCloudPhone Installer Updater.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.0
#
#   - 1.0 Martyn Watts, 22.06.2021 Initial Build
#   - 1.1 Martyn Watts, 24.09.2021 Added Check to see if dockutil is installed to make the script more resilient
#
####################################################################################################
# Script to download and install BT Cloud Phone.
# Only works on Intel systems.
#

downloadUrl='https://downloads.ringcentral.com/sp/bt/BTCloudPhoneForMac'
appName='BT Cloud Phone'
dmgVolume='BT Cloud Work Phone'
forceQuit='Y'
logfile="/Library/Logs/BTCloudPhoneInstallScript.log"

deplog="/var/tmp/depnotify.log"

echo "Status: Installing ${appName}" >> ${deplog}

#  To get just the latest version url and number from the download URL

url=$(curl -Ls -o /dev/null -w %{url_effective} ${downloadUrl})
latestver=$(echo ${url} | cut -f5 -d'-' | sed -e 's/\.[^.]*$//')
dnldfile=$(echo ${url} | sed -e 's:.*/::')

# Get the version number of the currently-installed App, if any.
    if [[ -e "/Applications/${appName}.app" ]]; then
        currentinstalledver=`/usr/bin/defaults read "/Applications/${appName}.app/Contents/Info" CFBundleShortVersionString`
        echo "Current installed version is: $currentinstalledver"
        echo "Current installed version is: $currentinstalledver" >> ${logfile}
        if [[ ${latestver} = ${currentinstalledver} ]]; then
            echo "${appName} is current. Exiting"
            echo "${appName} is current. Exiting" >> ${logfile}
            exit 0
        fi
    else
        currentinstalledver="none"
        echo "${appName} is not installed"
        echo "${appName} is not installed" >> ${logfile}
    fi


# Compare the two versions, if they are different or the App is not present then download and install the new version.
    if [[ "${currentinstalledver}" != "${latestver}" ]]; then
        /bin/echo "`date`: Current ${appName} version: ${currentinstalledver}" >> ${logfile}
    	/bin/echo "Current ${appName} version: ${currentinstalledver}"
        /bin/echo "`date`: Available ${appName} version: ${latestver}" >> ${logfile}
        /bin/echo "Available ${appName} version: ${latestver}"
        /bin/echo "`date`: Downloading newer version." >> ${logfile}
        /bin/echo "Downloading newer version."
        /usr/bin/curl -o "/tmp/${dnldfile}" ${url}
    	/bin/echo "`date`: Force quitting ${appName} if running." >> ${logfile}
    	/bin/echo "Force quitting ${appName} if running."

        	if [[ "${forceQuit}" = "Y" ]]; then
        		killall ${appName}
        	fi

		########################################################################################
		# Uncomment this block for dmg & .app copy   										   #
       	######################################################################################## 
       	/bin/echo "`date`: Mounting installer disk image." >> ${logfile}
       	/bin/echo "Mounting installer disk image."
       	/usr/bin/hdiutil attach /tmp/${dnldfile} -nobrowse -quiet
       	/bin/echo "`date`: Installing..." >> ${logfile}
       	/bin/echo "Installing..."
       	ditto -rsrc "/Volumes/${dmgVolume}/${appName}.app" "/Applications/${appName}.app"
       	/bin/sleep 10
       	/bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
       	/bin/echo "Unmounting installer disk image."
       	/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep '${dmgVolume}' | awk '{print $1}') -quiet
       	/bin/sleep 10
       	########################################################################################
       
      	########################################################################################
       	# Uncomment this block for .pkg install    											   #
       	########################################################################################
       	# cd /tmp
       	# /usr/sbin/installer -pkg ${dnldfile} -target /
	   	########################################################################################
       
       	/bin/sleep 5
        /bin/echo "`date`: Deleting the downloaded file." >> ${logfile}
        /bin/echo "Deleting the downloaded file."
        /bin/rm /tmp/${dnldfile}

        #double check to see if the new version got updated
        newlyinstalledver=`/usr/bin/defaults read "/Applications/${appName}.app/Contents/Info" CFBundleShortVersionString`
        if [[ "${latestver}" = "${newlyinstalledver}" ]]; then
            /bin/echo "`date`: SUCCESS: ${appName} has been updated to version ${newlyinstalledver}" >> ${logfile}
            /bin/echo "SUCCESS: ${appName} has been updated to version ${newlyinstalledver}"
            if [[ -e "/usr/local/bin/dockutil" ]]; then
            	/bin/echo "`date`: Creating Dock Icon." >> ${logfile}
				/usr/local/bin/dockutil --remove 'BT Cloud Work Phone' --allhomes
				/bin/sleep 3
				/usr/local/bin/dockutil --add '/Applications/BT Cloud Phone.app' --after 'Messages' --allhomes
			fi
            /bin/echo "--" >> ${logfile}
        else
            /bin/echo "`date`: ERROR: ${appName} update unsuccessful, version remains at ${currentinstalledver}." >> ${logfile}
            /bin/echo "ERROR: ${appName} update unsuccessful, version remains at ${currentinstalledver}."
            /bin/echo "--" >> ${logfile}
            exit 1
        fi

    # If App is up to date already, just log it and exit.       
    else
        /bin/echo "`date`: ${appName} is already up to date, running ${currentinstalledver}." >> ${logfile}
        /bin/echo "`date`: ${appName} is already up to date, running ${currentinstalledver}."
        /bin/echo "--" >> ${logfile}
    fi
    echo "Command: DeterminateManualStep: 1" >> ${deplog}

