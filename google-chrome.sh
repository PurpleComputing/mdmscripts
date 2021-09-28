#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   Install or update to the latest version - Google Chrome -- Installs or updates Google Chrome
#
# SYNOPSIS
#   sudo Install or update to the latest version - Google Chrome
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.2
#
#   - 1.0 Martyn Watts, 01.07.2021 Initial Build
#   - 1.1-m Michael Tanner, 18.08.2021 Adapted for Mosyle
#   - 1.2 Martyn Watts, 24.09.2021 Added Check to see if dockutil is installed to make the script more resilient
#   - 1.3 Martyn Watts, 28.09.2021 Added Open Console Parameter to use with TeamViewer
#
####################################################################################################
# Script to download and install Google Chrome.
#

# Unable to find a reliable web source of the latest version number
# We'll need to download the latest version and extract the version number from the pkg file
url='https://dl.google.com/chrome/mac/stable/gcem/GoogleChrome.pkg'
dnldfile='GoogleChrome.pkg'
appName='Google Chrome'
forceQuit='Y'
logfile="/Library/Logs/GoogleChromeInstallScript.log"
deplog="/var/tmp/depnotify.log"

if [[ $@ == "openconsole" ]]; then
	open ${logfile}
	open ${deplog}
fi

echo "Status: Installing ${appName}" >> ${deplog}

#  To get just the latest version number from the version check URL
/bin/echo "`date`: Downloading latest version." >> ${logfile}
/bin/echo "Downloading latest version."
/usr/bin/curl -o "/tmp/${dnldfile}" ${url}
/bin/echo "`date`: Expanding package." >> ${logfile}
/bin/echo "Expanding package."
pkgutil --expand "/tmp/${dnldfile}" /tmp/pkg
/bin/echo "`date`: Storing latest version data." >> ${logfile}
/bin/echo "Storing latest version data."
latestver=$(cat /tmp/pkg/Distribution | grep 'CFBundleShortVersionString' | cut -f2 -d '"')
/bin/echo "`date`: Removing expanded package" >> ${logfile}
/bin/echo "Removing expanded package."
/bin/rm -rf /tmp/pkg


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
    	/bin/echo "`date`: Force quitting ${appName} if running." >> ${logfile}
    	/bin/echo "Force quitting ${appName} if running."

        	if [[ "${forceQuit}" = "Y" ]]; then
        		killall ${appName}
        	fi
		cd /tmp
       	/usr/sbin/installer -pkg ${dnldfile} -target /

        #double check to see if the new version got updated
        newlyinstalledver=`/usr/bin/defaults read "/Applications/${appName}.app/Contents/Info" CFBundleShortVersionString`
        if [[ "${latestver}" = "${newlyinstalledver}" ]]; then
            /bin/echo "`date`: SUCCESS: ${appName} has been updated to version ${newlyinstalledver}" >> ${logfile}
            /bin/echo "SUCCESS: ${appName} has been updated to version ${newlyinstalledver}"
            if [[ -e "/usr/local/bin/dockutil" ]]; then  
 	       		/bin/echo "`date`: Removing Existing Dock Icon." >> ${logfile}
    	        /bin/echo "Removing Existing Dock Icon."           
				/usr/local/bin/dockutil --remove "${appName}" --allhomes >> ${logfile}
				/bin/sleep 5
				/bin/echo "`date`: Creating New Dock Icon." >> ${logfile}
       			/bin/echo "Creating New Dock Icon."
				/usr/local/bin/dockutil --add "/Applications/${appName}.app" --after 'Safari' --allhomes >> ${logfile}
			fi
        	/bin/sleep 3
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
    
        /bin/sleep 5
        /bin/echo "`date`: Deleting the downloaded file." >> ${logfile}
        /bin/echo "Deleting the downloaded file."
        /bin/rm /tmp/${dnldfile}
  echo "Command: DeterminateManualStep: 1" >> ${deplog}

