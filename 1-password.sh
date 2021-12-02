#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   1Password Installer Updater.sh -- Installs or updates 1Password 7
#
# SYNOPSIS
#   sudo 1Password Installer Updater.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.3
#
#   - 1.0 Martyn Watts, 25.06.2021 Initial Build
#   - 1.1 Martyn Watts, 01.07.2021 Increased script feedback
#   - 1.2 Martyn Watts, 22.09.2021 Fixed the exclusion of beta versions recently introduced into the release notes
#   - 1.3 Martyn Watts, 24.09.2021 Added Check to see if dockutil is installed to make the script more resilient
#   - 1.4 Martyn Watts, 28.09.2021 Added Open Console Parameter to use with TeamViewer
#   - 1.5 Martyn Watts, 29.09.2021 Removed erroneous space in deplog path, moved the Open Console section to below the initial creation event
#                                  & Created a scriptver variable that is recorded in the log files
#
####################################################################################################
# Script to download and install 1Password 7.
# Only works on Intel systems.
#

releaseNotesUrl='https://app-updates.agilebits.com/product_history/OPM7'
dnldfile='1Password.pkg'
appName='1Password 7'
forceQuit='Y'
logfile="/Library/Logs/1Password7InstallScript.log"
deplog="/var/tmp/depnotify.log"
scriptver="1.5"

/bin/echo "Status: Installing ${appName}" >> ${deplog}
/bin/echo "Status: Installing ${appName}" >> ${logfile}

if [[ $@ == "openconsole" ]]; then
	open ${logfile}
	open ${deplog}
fi

/bin/echo "Script Version: ${scriptver}" >> ${logfile}

#  To get just the latest version number from the 1Password 7 Release Notes URL
/bin/echo "`date`: Getting latest version number" >> ${logfile}
/bin/echo "Getting latest version number"
latestver=$(curl -s ${releaseNotesUrl} | grep '>download<' | grep -vim 1 'beta' | cut -f2 -d'"' | cut -f2 -d"-" | sed -e 's/\.[^.]*$//')

# To get the latest download link from the 1Password7 Release Notes URL
url=$(curl -s ${releaseNotesUrl} | grep '>download<' | grep -vim 1 'beta' | cut -f2 -d'"')

/bin/echo "`date`: Latest version number is: ${latestver}" >> ${logfile}
/bin/echo "Latest version number is: ${latestver}"


# Get the version number of the currently-installed App, if any.
    if [[ -e "/Applications/${appName}.app" ]]; then
        currentinstalledver=`/usr/bin/defaults read "/Applications/${appName}.app/Contents/Info" CFBundleShortVersionString`
        /bin/echo "Current installed version is: $currentinstalledver"
        /bin/echo "`date`: Current installed version is: $currentinstalledver" >> ${logfile}
        if [[ ${latestver} = ${currentinstalledver} ]]; then
            /bin/echo "${appName} is current. Exiting"
            /bin/echo "`date`: ${appName} is current. Exiting" >> ${logfile}
            /bin/echo "Status: ${appName} is current. Exiting" >> ${deplog}
            exit 0
        fi
    else
        currentinstalledver="none"
        /bin/echo "${appName} is not installed"
        /bin/echo "`date`: ${appName} is not installed" >> ${logfile}
    fi


# Compare the two versions, if they are different or the App is not present then download and install the new version.
    if [[ "${currentinstalledver}" != "${latestver}" ]]; then
        /bin/echo "`date`: Current ${appName} version: ${currentinstalledver}" >> ${logfile}
        /bin/echo "Current ${appName} version: ${currentinstalledver}"
        /bin/echo "`date`: Available ${appName} version: ${latestver}" >> ${logfile}
        /bin/echo "Available ${appName} version: ${latestver}"
        /bin/echo "`date`: Downloading newer version." >> ${logfile}
        /bin/echo "Downloading newer version."
        /usr/bin/curl -s -o /tmp/${dnldfile} ${url}
        	if [[ "${forceQuit}" = "Y" ]]; then
        		killall ${appName}
        	fi

		########################################################################################
		# Uncomment this block for dmg & .app copy   										   #
       	######################################################################################## 
       	# /bin/echo "`date`: Mounting installer disk image." >> ${logfile}
       	# /usr/bin/hdiutil attach /tmp/${dnldfile} -nobrowse -quiet
       	# /bin/echo "`date`: Installing..." >> ${logfile}
       	# ditto -rsrc "/Volumes/AppName/AppName.app" "/Applications/AppNAme.app"
       	# /bin/sleep 10
       	# /bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
       	# /usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep AppName | awk '{print $1}') -quiet
       	# /bin/sleep 10
       	########################################################################################
       
      	########################################################################################
       	# Uncomment this block for .pkg install    											   #
       	########################################################################################
       	cd /tmp
       	/usr/sbin/installer -pkg ${dnldfile} -target /
	   	########################################################################################
       
       	/bin/sleep 5
        /bin/echo "`date`: Deleting the downloaded file." >> ${logfile}
        /bin/rm /tmp/${dnldfile}

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
				/usr/local/bin/dockutil --add "/Applications/${appName}.app" --position 1  --allhomes >> ${logfile}
            	/bin/sleep 3
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
        /bin/echo "${appName} is already up to date, running ${currentinstalledver}."
        /bin/echo "--" >> ${logfile}
    fi
    /bin/echo "Command: DeterminateManualStep: 1" >> ${deplog}

