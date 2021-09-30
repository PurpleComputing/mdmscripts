#!/bin/sh
####################################################################################################
#                                                                                                  #
# ABOUT THIS PROGRAM                                                                               #
#                                                                                                  #
# NAME                                                                                             #
#   Brave Browser                                                                                  #
#                                                                                                  #
# SYNOPSIS                                                                                         #
#   sudo brave-browser.sh                                                                          #
#                                                                                                  #
####################################################################################################
#                                                                                                  #
# HISTORY                                                                                          #
#   Version: 1.0                                                                                   #
#                                                                                                  #
#   - 1.0 Martyn Watts, 30.09.2021 Initial Build                                                   #
#                                                                                                  #
####################################################################################################

####################################################################################################
#  Program Variables                                                                               #
####################################################################################################

# The version of this script, it is used in the logs so you can see which version of the script has
# been used and will help with script debugging
scriptver="1.0"

# The url of the webpage to scrape for the latest version number and download link.
releaseNotesUrl='https://brave.com/latest/'

# Installation Method, are we using a DMG or PKG to install the app?
installMethod="DMG"

# This is the name of the file we download this might be a dmg or a pkg.
dnldfile='Brave-Browser.dmg'

# The name of the application once it is installed without the .app extension
appName='Brave Browser'

# The variable to hold the architecture type
architecture=$(/usr/bin/arch)

# Do we want to force quit the existing application before updating
forceQuit='Y'

# The 2 Log files we create as were progressing through the script
# logfile is the main log which has each step and any errors sent to it
# deplog is used to update the depnotify application with statuses and increments the progress bar
logfile="/Library/Logs/Brave-BrowserInstallScript.log"
deplog="/var/tmp/depnotify.log"


####################################################################################################
#  Script Startup                                                                                  #
####################################################################################################

# Create log files if they don't exist
if [[ ! -e ${logfile} ]]; then 
/bin/echo "---- New Log ----" >> $logfile 
fi

if [[ ! -e ${deplog} ]]; then 
/bin/echo "---- New Log ----" >> $deplog 
fi

# Open the log files if the openconsole parameter has been passed to the script
if [[ $@ == "openconsole" ]]; then
	open ${logfile}
	open ${deplog}
fi

# Log the script version and date
/bin/echo "`date`: Running script version: ${scriptver}" >> ${logfile}


####################################################################################################
#  Gathering the latest version number                                                             #
####################################################################################################

#  To get just the latest version number from the Release Notes URL
/bin/echo "`date`: Getting latest version number" >> ${logfile}
/bin/echo "Getting latest version number"
latestver=$(curl -s ${releaseNotesUrl} | grep -m 1 'id="release-notes-v' | cut -f3 -d'>' | cut -f1 -d'<' | sed -e 's/[a-zA-Z]//' | sed -e 's/[\.]//')

####################################################################################################
#  Gathering the download url                                                                      #
####################################################################################################

# To get the latest download link from the Release Notes URL
/bin/echo "`date`: Getting download url" >> ${logfile}
/bin/echo "Getting download url"

if [[ $architecture == "arm64" ]]; then
	echo "Running Apple Silicon Setting correct URL"
	downloadUrl="https://laptop-updates.brave.com/latest/osxamd64"
else
	echo "Running Intel Setting correct URL"
	downloadUrl="https://laptop-updates.brave.com/latest/osx"
fi

# Display the latest version available in the logs
/bin/echo "`date`: Latest version number is: ${latestver}" >> ${logfile}
/bin/echo "Latest version number is: ${latestver}"

####################################################################################################
#  Check to see if app already installed and get the version if it is                              #
####################################################################################################

# Is the app already installed?
    if [[ -e "/Applications/${appName}.app" ]]; then
    
    # Read the version number from the info.plist
        currentinstalledver=`/usr/bin/defaults read "/Applications/${appName}.app/Contents/Info" CFBundleVersion`
        
        # Display the current installed version number in the logs
        /bin/echo "Current installed version is: $currentinstalledver"
        /bin/echo "`date`: Current installed version is: $currentinstalledver" >> ${logfile}
        
        # Check to see if the latest available version is the same as the installed version
        if [[ ${latestver} = ${currentinstalledver} ]]; then
            /bin/echo "${appName} is current. Exiting"
            /bin/echo "`date`: ${appName} is current. Exiting" >> ${logfile}
            /bin/echo "Status: ${appName} is current. Exiting" >> ${deplog}
            exit 0
        fi
    else
    	# update the logs to indicate that app is not already installed
        currentinstalledver="none"
        /bin/echo "${appName} is not installed"
        /bin/echo "`date`: ${appName} is not installed" >> ${logfile}
    fi


####################################################################################################
#  Compare the two versions, if they are different or the App is not present then download and     #
#  install the new version.                                                                        #
####################################################################################################

# Check to see if the versions do not match 
    if [[ "${currentinstalledver}" != "${latestver}" ]]; then
    
    # Display current and available versions in the logs
        /bin/echo "`date`: Current ${appName} version: ${currentinstalledver}" >> ${logfile}
        /bin/echo "Current ${appName} version: ${currentinstalledver}"
        /bin/echo "`date`: Available ${appName} version: ${latestver}" >> ${logfile}
        /bin/echo "Available ${appName} version: ${latestver}"
        
        # Download the file
        /bin/echo "`date`: Downloading newer version." >> ${logfile}
        /bin/echo "Downloading newer version."
    	url=$(curl -Ls -o /dev/null -w %{url_effective} ${downloadUrl})
        /usr/bin/curl -s -o /tmp/${dnldfile} ${url}

        
        # Force quit the application
        	if [[ "${forceQuit}" = "Y" ]]; then
        		killall ${appName}
        	fi
####################################################################################################
#  Choose the correct installation method.                                                          #
####################################################################################################

	if [[ "${installMethod}" = "DMG" ]]; then

		# Mount the DMG
       	/bin/echo "`date`: Mounting installer disk image." >> ${logfile}
       	/usr/bin/hdiutil attach /tmp/${dnldfile} -nobrowse
       	
       	# Copy the file to the Applications folder - you may need to change the mounted volume name
       	/bin/echo "`date`: Installing..." >> ${logfile}
       	ditto -rsrc "/Volumes/${appName}/${appName}.app" "/Applications/${appName}.app"
       	/bin/sleep 10
       	
       	# Unmount the DMG
       	/bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
       	/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep ${appName} | awk '{print $1}') -quiet
       	/bin/sleep 10
       
    else
       
       
		# Open the PKG with installer
       	cd /tmp
       	/usr/sbin/installer -pkg ${dnldfile} -target /
       
       
    fi
     	# Clean up after the installation
       	/bin/sleep 5
        /bin/echo "`date`: Deleting the downloaded file." >> ${logfile}
        /bin/rm /tmp/${dnldfile}
        
        
####################################################################################################
#  Check to see if the update was successful.                                                      #
####################################################################################################

		# Get the version of the app from the info.plist
        newlyinstalledver=`/usr/bin/defaults read "/Applications/${appName}.app/Contents/Info" CFBundleVersion`
        
        # Compare the installed version against the latest version
        if [[ "${latestver}" = "${newlyinstalledver}" ]]; then
            /bin/echo "`date`: SUCCESS: ${appName} has been updated to version ${newlyinstalledver}" >> ${logfile}
            /bin/echo "SUCCESS: ${appName} has been updated to version ${newlyinstalledver}"
            
            # If dockutil is installed remove existing dock icon and add new one
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
        # Update log with Failed install and exit with exit code 1
        else
            /bin/echo "`date`: ERROR: ${appName} update unsuccessful, version remains at ${currentinstalledver}." >> ${logfile}
            /bin/echo "ERROR: ${appName} update unsuccessful, version remains at ${currentinstalledver}."
            /bin/echo "---- End of script ----" >> ${logfile}
            exit 1
        fi

    # App is up to date already so we log it.       
    else
        /bin/echo "`date`: ${appName} is already up to date, running ${currentinstalledver}." >> ${logfile}
        /bin/echo "${appName} is already up to date, running ${currentinstalledver}."
    fi
    
    # Update log so show end of script
    /bin/echo "---- End of script ----" >> ${logfile}
    
    # Update DEP Notify to increment the progress bar - when used with multiple scripts
    /bin/echo "Command: DeterminateManualStep: 1" >> ${deplog}
    
    #Exit script with exit code 0
    exit 0
