#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   FirefoxInstall.sh -- Installs or updates Firefox
#
# SYNOPSIS
#   sudo FirefoxInstall.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.7
#
#   - 1.0 Joe Farage, 18.03.2015
#   - 1.0.1 Chris Hansen, 14.05.2020 Some square brackets change to double square brackets
#   - 1.1 Martyn Watts, 24.05.2020 Removed Language Variables as they are not needed and results were inconsistent
#   - 1.2 Martyn Watts, 30.06.2021 Added dock icon for all users using dockutil (prerequisite)
#   - 1.3 Michael Tanner, 18.08.2021 Adapted for use with Mosyle
#   - 1.4 Martyn Watts, 24.09.2021 Added Check to see if dockutil is installed to make the script more resilient
#   - 1.5 Martyn Watts, 28.09.2021 Added Open Console Parameter to use with TeamViewer
#   - 1.6 Martyn Watts, 29.09.2021 Added scriptver variable and sending this to the logfile
#   - 1.7 Martyn Watts, 03.12.2012 Changed the /tmp paths to /Library/Caches/com.purplecomputing.mdm/
#
####################################################################################################
# Script to download and install Firefox.
# Only works on Intel systems.
#

# Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Logs/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/

dmgfile="FF.dmg"
logfile="/Library/Caches/com.purplecomputing.mdm/Logs/FirefoxInstallScript.log"
deplog="/var/tmp/depnotify.log"
scriptver="1.7"

echo "Script Version: ${scriptver}" >> ${logfile}

if [[ $@ == "openconsole" ]]; then
	open ${logfile}
	open ${deplog}
fi

echo "Status: Installing Firefox" >> ${deplog}
echo "Status: Installing Firefox" >> ${logfile}

# Are we running on Intel?
if [ '`/usr/bin/uname -p`'="i386" -o '`/usr/bin/uname -p`'="x86_64" ]; then
	## Get OS version and adjust for use with the URL string
	OSvers_URL=$( sw_vers -productVersion | sed 's/[.]/_/g' )

	## Set the User Agent string for use with curl
	userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"

	# Get the latest version of Browser available from Firefox page.
	latestver=`/usr/bin/curl -s -A "$userAgent" https://www.mozilla.org/en-US/firefox/new/ | grep 'data-latest-firefox' | sed -e 's/.* data-latest-firefox="\(.*\)".*/\1/' -e 's/\"//' | /usr/bin/awk '{print $1}'`
	echo "Latest Version is: $latestver"

	# Get the version number of the currently-installed FF, if any.
	if [[ -e "/Applications/Firefox.app" ]]; then
		currentinstalledver=`/usr/bin/defaults read /Applications/Firefox.app/Contents/Info CFBundleShortVersionString`
		echo "Current installed version is: $currentinstalledver"
		if [[ ${latestver} = ${currentinstalledver} ]]; then
			echo "Firefox is current. Exiting"
			exit 0
		fi
	else
		currentinstalledver="none"
		echo "Firefox is not installed"
	fi

	url="https://download-installer.cdn.mozilla.net/pub/firefox/releases/${latestver}/mac/en-US/Firefox%20${latestver}.dmg"
	echo "Latest version of the URL is: $url"
	echo "`date`: Download URL: $url" >> ${logfile}

	# Compare the two versions, if they are different or Firefox is not present then download and install the new version.
	if [[ "${currentinstalledver}" != "${latestver}" ]]; then
		/bin/echo "`date`: Current Firefox version: ${currentinstalledver}" >> ${logfile}
		/bin/echo "`date`: Available Firefox version: ${latestver}" >> ${logfile}
		/bin/echo "`date`: Downloading newer version." >> ${logfile}
		/usr/bin/curl -s -o /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile} ${url}
		/bin/echo "`date`: Mounting installer disk image." >> ${logfile}
		/usr/bin/hdiutil attach /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile} -nobrowse -quiet
		/bin/echo "`date`: Installing..." >> ${logfile}
		ditto -rsrc "/Volumes/Firefox/Firefox.app" "/Applications/Firefox.app"

		/bin/sleep 10
		/bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
		/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep Firefox | awk '{print $1}') -quiet
		/bin/sleep 10
		/bin/echo "`date`: Deleting disk image." >> ${logfile}
		/bin/rm /Library/Caches/com.purplecomputing.mdm/Apps/${dmgfile}

		#double check to see if the new version got updated
		newlyinstalledver=`/usr/bin/defaults read /Applications/Firefox.app/Contents/Info CFBundleShortVersionString`
		if [[ "${latestver}" = "${newlyinstalledver}" ]]; then
			/bin/echo "`date`: SUCCESS: Firefox has been updated to version ${newlyinstalledver}" >> ${logfile}
			if [[ -e "/usr/local/bin/dockutil" ]]; then  
				/bin/echo "`date`: Creating Dock Icon." >> ${logfile}
				/usr/local/bin/dockutil --remove 'Firefox' --allhomes
				/bin/sleep 3
				/usr/local/bin/dockutil --add '/Applications/Firefox.app' --after 'Safari' --allhomes
			fi
			/bin/echo "--" >> ${logfile}
		else
			/bin/echo "`date`: ERROR: Firefox update unsuccessful, version remains at ${currentinstalledver}." >> ${logfile}
			/bin/echo "--" >> ${logfile}
			exit 1
		fi

	# If Firefox is up to date already, just log it and exit.       
	else
		/bin/echo "`date`: Firefox is already up to date, running ${currentinstalledver}." >> ${logfile}
		/bin/echo "--" >> ${logfile}
	fi  
else
	/bin/echo "`date`: ERROR: This script is for Intel Macs only." >> ${logfile}
fi
echo "Command: DeterminateManualStep: 1" >> ${deplog}
exit 0
