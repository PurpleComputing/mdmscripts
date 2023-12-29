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
#   Version: 1.2
#
#   - 1.0 Martyn Watts, 25.06.2021 Initial Build
#   - 1.1 Martyn Watts, 29.09.2021 Removed erroneous space in deplog path, moved the Open Console section to below the initial creation event
#                                  & Created a scriptver variable that is recorded in the log files
#   - 1.2 Martyn Watts, 03.12.2012 Changed the /tmp paths to /Library/Caches/com.purplecomputing.mdm/
#
####################################################################################################
# Script to identify architecture and install Rosetta2 if needed
#
appName="Rosetta 2"
logfile="/Library/Caches/com.purplecomputing.mdm/Logs/Rosetta2InstallScript.log"
deplog="/var/tmp/depnotify.log"
scriptver="1.2"

# Making Purple Cache directories for in the event that the helper script hasn't been run


mkdir -p /Library/Logs/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/

/bin/echo "Status: Installing ${appName} ..." >> ${deplog}
/bin/echo "Status: Installing ${appName}" >> ${logfile}

if [[ $1 == "openconsole" ||  $2 == "openconsole" ]]; then
	open ${logfile}
	open ${deplog}
fi

/bin/echo "Script Version: ${scriptver}" >> ${logfile}

arch=$(/usr/bin/arch)
if [ "$arch" == "arm64" ]; then
    echo "Status: Apple Silicon - Installing Rosetta ..." >> ${logfile}
    echo "Status: Apple Silicon - Installing Rosetta" >> ${deplog}
    echo "Status: Apple Silicon - Installing Rosetta"
    sleep 1
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    echo "Status: Rosetta 2 Now Installed ..." >> ${deplog}
    echo "Status: Rosetta 2 Now Installed" >> ${logfile}
    echo "Status: Rosetta 2 Now Installed" 
    sleep 2
elif [ "$arch" == "i386" ]; then
    echo "Status: Intel - Skipping Rosetta ..." >> ${deplog}
    echo "Status: Intel - Skipping Rosetta" >> ${logfile}
    echo "Status: Intel - Skipping Rosetta"
    sleep 3
else
    echo "Status: Unknown Architecture..." >> ${deplog}
    echo "Status: Unknown Architecture" >> ${logfile}
    echo "Status: Unknown Architecture"
    sleep 3
fi

if [[ $1 == "jamf" ||  $2 == "jamf" ]]; then
echo "Found the jamf parameter so running a recon" >> ${logfile}
echo "Running recon so Architecture gets updated and arch based smart groups work" >> ${logfile}
jamf recon
fi
exit 0
