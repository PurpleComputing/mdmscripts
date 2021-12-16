#!/bin/sh
#########################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   ZeroTier Install Script
#
# SYNOPSIS
# zerotier2.sh
# FOR INITIAL DEPLOYMENT OR ENROLMENT USE ONLY
#########################################################################
#
# HISTORY
#
#   Version: 1.0
#
#   - 1.0 Martyn Watts, 16.12.2021 Initial Script Template Build
#
#########################################################################
# Script to install ZeroTier and to join the organisations ZT Network.
#
scriptver='1.0'
logfile="/Library/Logs/com.purplecomputing.mdm/ZeroTierInstallScript.log"
appName="ZeroTier"
deplog="/var/tmp/depnotify.log"

#Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Logs/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/

echo "Status: Installing ${appName} using script version ${scriptver}" >> ${deplog}
echo "Status: Installing ${appName} using script version ${scriptver}" >> ${logfile}

echo "Status: Downloading ZeroTier" >> ${logfile}
echo "Status: Downloading ZeroTier" >> ${deplog}

# Using 1.8.3 version to stop the continual prompts for credentials
curl -o /Library/Caches/com.purplecomputing.mdm/Apps/ZT.pkg https://download.zerotier.com/RELEASES/1.8.3/dist/ZeroTierOne.pkg
#curl -o /Library/Caches/com.purplecomputing.mdm/Apps/ZT.pkg https://download.zerotier.com/dist/ZeroTier%20One.pkg

echo "Status: Running the installer" >> ${logfile}
echo "Status: Running the installer" >> ${deplog}
installer -pkg /Library/Caches/com.purplecomputing.mdm/Apps/ZT.pkg -target /
sleep 5

# Kill off the ZeroTier.app and then ZeroTier auth copy processes
echo "Status: Killing Processes" >> ${logfile}
echo "Status: Killing Processes" >> ${deplog}
app-pid=$(ps aux | grep 'ZeroTier' | grep -v 'grep' | grep -v 'security' | awk '{print$2}')
auth-pid=$(ps aux | grep 'ZeroTier' | grep 'security' | grep -v 'grep' | awk '{print$2}');
kill -9 $app-pid
kill -9 $auth-pid
#This sleep is functional and is needed to allow the processes to close properly before reopening the application
sleep 5

# Now start the ZeroTier.app again as user and we then only enter the admin credentials once
echo "Status: Re-opening ZeroTier" >> ${logfile}
echo "Status: Re-opening ZeroTier" >> ${deplog}
sudo -u $(stat -f "%Su" /dev/console) open /Applications/ZeroTier.app
sleep 5

echo "Status: Cleaning up after the installer" >> ${logfile}
echo "Status: Cleaning up after the installer" >> ${deplog}
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/ZT.pkg
sleep 2

echo "Status: Joining ZeroTier to network ${@}" >> ${logfile}
echo "Status: Joining ZeroTier to network ${@}" >> ${deplog}
/usr/local/bin/zerotier-cli join $@

exit 0