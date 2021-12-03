#!/bin/zsh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   Zoom Installer Updater.sh -- Installs or updates Zoom
#
# SYNOPSIS
#   sudo zoom.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.2
#
#   - 1.0 Martyn Watts, 28.09.2021 Initial Build
#   - 1.1 Martyn Watts, 28.09.2021 Initial Build
#   - 1.1.1 Martyn Watts, 28.09.2021 Initial Build
#   - 1.2 Martyn Watts, 03.12.2012 Changed the /tmp paths to /Library/Caches/com.purplecomputing.mdm/
#
####################################################################################################
# Script to download and install Zoom.
#

releaseNotesUrl='https://zoom.us/download'
appName='zoom.us'
dnldfile='zoom.pkg'
forceQuit='Y'
logfile="/Library/Caches/com.purplecomputing.mdm/Logs/ZoomInstallScript.log"
deplog="/var/tmp/depnotify.log"
scriptver="1.2"
architecture=$(/usr/bin/arch)
OSvers_URL=$( sw_vers -productVersion | sed 's/[.]/_/g' )
userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"

# Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Logs/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/

echo "Script Version: ${scriptver}" >> ${logfile}
echo "Status: Installing ${appName}" >> ${deplog}
echo "Status: Installing ${appName}" >> ${logfile}

if [[ $@ == "openconsole" ]]; then
	open ${logfile}
	open ${deplog}
fi

#  To get just the latest version url and number from the download URL

latestver=$(curl -A ${userAgent} ${releaseNotesUrl} | iconv -f windows-1251 | grep -m 1 'Version' | cut -f2 -d' ')
echo "Latest version available is: $latestver"


if [[ $architecture == "arm64" ]]; then
	echo "Running Apple Silicon Setting correct URL"
	downloadUrl="http://zoom.us/client/latest/Zoom.pkg?archType=arm64"
else
	echo "Running Intel Setting correct URL"
	downloadUrl="http://zoom.us/client/latest/Zoom.pkg"
fi

# Get the version number of the currently-installed App, if any.
    if [[ -e "/Applications/${appName}.app" ]]; then
		currentinstalledlongver=`/usr/bin/defaults read "/Applications/${appName}.app/Contents/Info" CFBundleShortVersionString`
		currentinstalledver=$(echo $currentinstalledlongver | cut -f1 -d' ')
	    echo "Current installed version is: $currentinstalledver"
        echo "Current installed version is: $currentinstalledver" >> ${logfile}
        if [[ $latestver = $currentinstalledver ]]; then
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
    if [[ $currentinstalledver != $latestver ]]; then
        /bin/echo "`date`: Current ${appName} version: ${currentinstalledver}" >> ${logfile}
    	/bin/echo "Current ${appName} version: ${currentinstalledver}"
        /bin/echo "`date`: Available ${appName} version: ${latestver}" >> ${logfile}
        /bin/echo "Available ${appName} version: ${latestver}"
        /bin/echo "`date`: Downloading newer version." >> ${logfile}
        /bin/echo "Downloading newer version."
        url=$(curl -Ls -o /dev/null -w %{url_effective} ${downloadUrl})
        /usr/bin/curl -o "/Library/Caches/com.purplecomputing.mdm/Apps/${dnldfile}" ${url}
    	/bin/echo "`date`: Force quitting ${appName} if running." >> ${logfile}
    	/bin/echo "Force quitting ${appName} if running."

        	if [[ "${forceQuit}" = "Y" ]]; then
        		killall ${appName}
        	fi

       	 cd /Library/Caches/com.purplecomputing.mdm/Apps/
       	 /usr/sbin/installer -pkg $dnldfile -target /
       
       	/bin/sleep 5
        /bin/echo "`date`: Deleting the downloaded file." >> ${logfile}
        /bin/echo "Deleting the downloaded file."
        /bin/rm /Library/Caches/com.purplecomputing.mdm/Apps/${dnldfile}

        #double check to see if the new version got updated
		newlyinstalledlongver=`/usr/bin/defaults read "/Applications/${appName}.app/Contents/Info" CFBundleShortVersionString`
		newlyinstalledver=$(echo ${newlyinstalledlongver} | cut -f1 -d' ')
		echo "Current installed version is: $currentinstalledver"
        if [[ $latestver == $newlyinstalledver ]]; then
            /bin/echo "`date`: SUCCESS: ${appName} has been updated to version ${newlyinstalledver}" >> ${logfile}
            /bin/echo "SUCCESS: ${appName} has been updated to version ${newlyinstalledver}"
            if [[ -e "/usr/local/bin/dockutil" ]]; then
            	/bin/echo "`date`: Creating Dock Icon." >> ${logfile}
				/usr/local/bin/dockutil --remove "${appName}" --allhomes
				/bin/sleep 3
				/usr/local/bin/dockutil --add "/Applications/${appName}.app" --after 'Messages' --allhomes
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
    
 sleep 5s   
 killall ${appName}

