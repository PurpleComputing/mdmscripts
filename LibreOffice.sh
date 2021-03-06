#!/bin/zsh
#########################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   LibreOffice 
#
# SYNOPSIS
#   sudo libreoffice.sh
#
#########################################################################
#
# HISTORY
#
#   Version: 1.3
#
#   - 1.0 Martyn Watts, 28.09.2021 Initial Build
#   - 1.1 Martyn Watts, 29.09.2021 First working build
#   - 1.2 Martyn Watts, 29.09.2021 Extended log information around the download, mount, copy & unmount operations
#   - 1.3 Martyn Watts, 03.12.2012 Changed the /tmp paths to /Library/Caches/com.purplecomputing.mdm/
#
#########################################################################
# Script to download and install LibreOffice.
#

scriptver='1.3'
releaseNotesUrl='https://www.libreoffice.org/download/download/'
dnldfile='LibreOffice.dmg'
appName='LibreOffice'
forceQuit='Y'
logfile="/Library/Caches/com.purplecomputing.mdm/Logs/${appName}.log"
deplog="/var/tmp/depnotify.log"
userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"

# Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Logs/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/

/bin/echo "Version: Script version ${scriptver}" >> ${deplog}
/bin/echo "Version: Script version ${scriptver}" >> ${logfile}

if [[ $@ == "openconsole" ]]; then
	open ${logfile}
	open ${deplog}
fi

/bin/echo "Status: Installing ${appName}" >> ${deplog}
/bin/echo "Status: Installing ${appName}" >> ${logfile}

#  To get just the latest version number from the Release Notes URL
/bin/echo "`date`: Getting latest version number" >> ${logfile}
/bin/echo "Getting latest version number"
latestver=$(curl -s -A ${userAgent} ${releaseNotesUrl} | grep -m 1 'dl_version_number' | cut -f3 -d'>' | cut -f1 -d'<')

# To get the latest download link from the Release Notes URL
dlurl=$(curl -s -A ${userAgent} ${releaseNotesUrl} | grep -m 1 'dl_download_link' | cut -f4 -d'"')
dlrdurl=$(curl -s -A ${userAgent} ${dlurl} | iconv -f windows-1251  | grep -m 1 'Refresh' | cut -f4 -d'=' | cut -f1 -d'"')
url=$(curl -s -A ${userAgent} ${dlrdurl} | iconv -f windows-1251  | grep -m 1 'href' | cut -f2 -d'"')
/bin/echo "`date`: Latest version number is: ${latestver}" >> ${logfile}
/bin/echo "Latest version number is: ${latestver}"


# Get the version number of the currently-installed App, if any.
if [[ -e "/Applications/${appName}.app" ]]; then
	currentinstalledver=`/usr/bin/defaults read "/Applications/${appName}.app/Contents/Info" CFBundleShortVersionString`
	currentinstalledver=${currentinstalledver%.*}
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
    /bin/echo ${url} >> ${logfile}
    curl -o /Library/Caches/com.purplecomputing.mdm/Apps/${dnldfile} ${url}
    if [[ "${forceQuit}" = "Y" ]]; then
      killall ${appName}
    fi
	
	/bin/echo "`date`: Mounting installer disk image." >> ${logfile}
	/usr/bin/hdiutil attach /Library/Caches/com.purplecomputing.mdm/Apps/${dnldfile} -nobrowse >> ${logfile}
	/bin/sleep 5
	/bin/echo "`date`: Installing..." >> ${logfile}	
	ditto -rsrc "/Volumes/${appName}/${appName}.app" "/Applications/${appName}.app"
	/bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
	/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep ${appName} | awk '{print $1}') >> ${logfile}       
    /bin/sleep 5
    /bin/echo "`date`: Deleting the downloaded file." >> ${logfile}
    /bin/rm /Library/Caches/com.purplecomputing.mdm/Apps/${dnldfile}

# Double check to see if the new version got updated
newlyinstalledver=`/usr/bin/defaults read "/Applications/${appName}.app/Contents/Info" CFBundleShortVersionString`
newlyinstalledver=${newlyinstalledver%.*}
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

else
# If App is up to date already, just log it and exit.       
        /bin/echo "`date`: ${appName} is already up to date, running ${currentinstalledver}." >> ${logfile}
        /bin/echo "${appName} is already up to date, running ${currentinstalledver}."
        /bin/echo "--" >> ${logfile}
fi
/bin/echo "Command: DeterminateManualStep: 1" >> ${deplog}
