#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   Rosetta2.sh -- Installs Rosetta2 if the architecture is correct
#
# SYNOPSIS
#   sudo Rosetta2.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.1
#
#   - 1.0 Martyn Watts, 25.06.2021 Initial Build
#   - 1.1 Martyn Watts, 29.09.2021 Removed erroneous space in deplog path, moved the Open Console section to below the initial creation event
#                                  & Created a scriptver variable that is recorded in the log files
#
####################################################################################################
# Script to identify architecture and install Rosetta2 if needed
#

logfile="/Library/Logs/Rosetta2InstallScript.log"
deplog="/var/tmp/depnotify.log"
scriptver="1.1"

/bin/echo "Status: Installing ${appName}" >> ${deplog}
/bin/echo "Status: Installing ${appName}" >> ${logfile}

if [[ $1 == "openconsole" ||  $2 == "openconsole" ]]; then
	open ${logfile}
	open ${deplog}
fi

/bin/echo "Script Version: ${scriptver}" >> ${logfile}

arch=$(/usr/bin/arch)
if [ "$arch" == "arm64" ]; then
    echo "Apple Silicon - Installing Rosetta" >> ${logfile}
    echo "Apple Silicon - Installing Rosetta" >> ${deplog}
    sleep 1
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    echo "Rosetta 2 Now Installed" >> ${deplog}
    echo "Rosetta 2 Now Installed" >> ${logfile}
    sleep 5
elif [ "$arch" == "i386" ]; then
    echo "Intel - Skipping Rosetta" >> ${deplog}
    echo "Intel - Skipping Rosetta" >> ${logfile}
    sleep 1
else
    echo "Unknown Architecture" >> ${deplog}
    echo "Unknown Architecture" >> ${logfile}
    sleep 1
fi

if [[ $1 == "jamf" ||  $2 == "jamf" ]]; then
echo "Found the jamf parameter so running a recon" >> ${logfile}
echo "Running recon so Architecture gets updated and arch based smart groups work" >> ${deplog}
echo "Running recon so Architecture gets updated and arch based smart groups work" >> ${logfile}
jamf recon
fi
exit 0
