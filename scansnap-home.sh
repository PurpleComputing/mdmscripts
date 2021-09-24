#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   ScanSnap Home Installer Updater.sh -- Installs or updates ScanSnap Home
#
# SYNOPSIS
#   sudo ScanSnap Home Installer Updater.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.1
#
#   - 1.0 Martyn Watts, 13.08.2021 Initial Build
#   - 1.1 Martyn Watts, 23.08.2021 Bug Fix for a incorrectly reporting failed install
#   - 1.2 Martyn Watts, 24.09.2021 Added Check to see if dockutil is installed to make the script more resilient
#
####################################################################################################
# Script to download and install ScanSnap Home.
#

siteRootUrl='https://scansnap.fujitsu.com'
downloadPageUrl=${siteRootUrl}'/global/dl/mac-sshoffline.html'
appName='ScanSnap Home'
installedAppName='ScanSnapHomeMain'
forceQuit='Y'
logfile="/Library/Logs/ScanSnapHomeInstallScript.log"
deplog="/var/tmp/depnotify.log"
scriptversion="1.1"

echo "Status: Installing ${appName} using script version ${scriptversion}" >> ${deplog}

#  To get just the latest version number from the ScanSnap Home Download Page URL
/bin/echo "`date`: Getting latest version number" >> ${logfile}
latestver=$(curl -s ${downloadPageUrl} | grep 'dlpage01' | cut -f4 -d ',' | cut -f5 -d '/' | sed 's/[^0-9]*//g')

# To get the latest download link from the ScanSnap Manager Download Page URL
urlPath=$(curl -s ${downloadPageUrl} | grep 'dlpage01' | cut -f8 -d "'")
downloadLinkUrl=${siteRootUrl}${urlPath}
url=$(curl -s ${downloadLinkUrl} | grep dmg | cut -f12 -d"'")
dnldfile=$(echo $url | sed 's:.*/::')

/bin/echo "Latest version number is ${latestver}" >> ${logfile}
/bin/echo "Latest version number is ${latestver}"

# Get the version number of the currently-installed App, if any.
    if [[ -e "/Applications/${installedAppName}.app" ]]; then
        currentinstalledver=$(/usr/bin/defaults read "/Applications/${installedAppName}.app/Contents/Info" CFBundleShortVersionString)
        currentinstalledvertidy=$(echo ${currentinstalledver} | sed 's/[^0-9]*//g')
		/bin/echo "`date`: Current installed version is: $currentinstalledver" >> ${logfile}
        /bin/echo "Current installed version is: $currentinstalledver"
        if [[ ${latestver} = ${currentinstalledvertidy} ]]; then
            /bin/echo "`date`: ${installedAppName} is current. Exiting" >> ${logfile}
        	/bin/echo "${installedAppName} is current. Exiting"
            exit 0
        fi
    else
        currentinstalledver="none"
        /bin/echo "`date`: ${installedAppName} is not installed" >> ${logfile}
        /bin/echo "${installedAppName} is not installed"
    fi


# Compare the two versions, if they are different or the App is not present then download and install the new version.
    if [[ "${currentinstalledver}" != "${latestver}" ]]; then
        /bin/echo "`date`: Current ${installedAppName} version: ${currentinstalledver}" >> ${logfile}
        /bin/echo "Current ${installedAppName} version: ${currentinstalledver}"
        /bin/echo "`date`: Available ${installedAppName} version: ${latestver}" >> ${logfile}
        /bin/echo "Available ${appName} version: ${latestver}"
        /bin/echo "`date`: Downloading newer version." >> ${logfile}
        /bin/echo "Downloading newer version."
        /usr/bin/curl -s -o /tmp/${dnldfile} ${url}
        /bin/echo "`date`: Force quitting existing app." >> ${logfile}
        /bin/echo "Force quitting existing app."
        	if [[ "${forceQuit}" = "Y" ]]; then
        		pkill -f ScanSnap
        	fi

		########################################################################################
		# Uncomment this block for dmg & .pkg install   									   #
       	######################################################################################## 
       	/bin/echo "`date`: Mounting installer disk image." >> ${logfile}
       	/bin/echo "Mounting installer disk image."
       	/usr/bin/hdiutil attach /tmp/${dnldfile} -nobrowse -quiet
       	/bin/echo "`date`: Installing..." >> ${logfile}
       	/bin/echo "Installing..."
       	dmgVolume=$(echo ${dnldfile} | cut -f1 -d'.')
       	offlinedmg=$(echo ${dnldfile} | sed 's/Offline/ome/' )
       	/usr/bin/hdiutil attach /Volumes/${dmgVolume}/Download/${offlinedmg} -nobrowse -quiet
       	dmgVolume1=$(echo ${offlinedmg} | cut -f1 -d'.')
       	cd /Volumes/$dmgVolume1
        /usr/sbin/installer -pkg "${appName}.pkg" -target /       	
       	/bin/sleep 10
       	/bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
       	/bin/echo "Unmounting installer disk image."
       	/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep '${dmgVolume1}' | awk '{print $1}') -quiet
       	/bin/sleep 10
       	/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep '${dmgVolume}' | awk '{print $1}') -quiet
       	/bin/sleep 10
       	########################################################################################
       
       	/bin/sleep 5
        /bin/echo "`date`: Deleting the downloaded file." >> ${logfile}
        /bin/echo "Deleting the downloaded file."
        /bin/rm /tmp/${dnldfile}

        #double check to see if the new version got updated
        newlyinstalledver=$(/usr/bin/defaults read "/Applications/${installedAppName}.app/Contents/Info" CFBundleShortVersionString)
        newlyinstalledvertidy=$(echo ${newlyinstalledver} | sed 's/[^0-9]*//g')
        if [[ "${latestver}" = "${newlyinstalledvertidy}" ]]; then
            /bin/echo "`date`: SUCCESS: ${installedAppName} has been updated to version ${newlyinstalledver}" >> ${logfile}
            /bin/echo "SUCCESS: ${installedAppName} has been updated to version ${newlyinstalledver}"
            if [[ -e "/usr/local/bin/dockutil" ]]; then  
            	/bin/echo "`date`: Removing Existing Dock Icon." >> ${logfile}
            	/bin/echo "Removing Existing Dock Icon."           
				/usr/local/bin/dockutil --remove "${appName}" --allhomes >> ${logfile}
				/bin/sleep 5
				/bin/echo "`date`: Creating New Dock Icon." >> ${logfile}
            	/bin/echo "Creating New Dock Icon."
				/usr/local/bin/dockutil --add "/Applications/${installedAppName}.app" --position 0 --allhomes >> ${logfile}
            	/bin/sleep 3
            fi
            /bin/echo "--" >> ${logfile}
            
            
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
        /bin/echo "{appName} is already up to date, running ${currentinstalledver}."
        /bin/echo "--" >> ${logfile}
    fi 

echo "Command: DeterminateManualStep: 1" >> ${deplog}




