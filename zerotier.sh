#!/bin/sh
#########################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   ZeroTier Install Script
#
# SYNOPSIS
# zerotier.sh
# FOR INITIAL DEPLOYMENT OR ENROLMENT USE ONLY
#########################################################################
#
# HISTORY
#
#   Version: 1.5
#
#   - 1.0 Martyn Watts, 25.06.2021 Initial Script Template Build
#   - 1.1 Michael Tanner, 28.09.2021 Implement ZeroTier Install Script
#   - 1.2 Martyn Watts, 29.09.2021 Added logging information
#   - 1.3 Michael Tanner, 06.11.2021 fixing /tmp folder usage for Monterey
#   - 1.4 Michael Tanner, reverted back to latest version
#   - 1.5 Michael Tanner, added killing of processes on initial install
#                         to aid with silent bg operation.
#
#########################################################################
# Script to install ZeroTier and to join the organisations ZT Network.
#
scriptver='1.5'
logfile="/Library/Logs/com.purplecomputing.mdm/ZeroTierInstallScript.log"
appName="ZeroTier"
deplog="/var/tmp/depnotify.log"

#Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Logs/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/

echo "Status: Installing $appName" >> $deplog
echo "Status: Installing ${appName} using script version ${scriptver}" >> ${logfile}

echo "Status: Downloading ZeroTier" >> ${logfile}
echo "Status: Downloading ZeroTier" >> $deplog

curl -s -o /Library/Caches/com.purplecomputing.mdm/Apps/ZT.pkg https://download.zerotier.com/dist/ZeroTier%20One.pkg

echo "Status: Running the installer" >> ${logfile}
echo "Status: Running the ZeroTier installer" >> $deplog
echo "-- INSTALLING ZEROTIER --"

installer -pkg /Library/Caches/com.purplecomputing.mdm/Apps/ZT.pkg -target /

echo "Status: Cleaning up after the installer" >> ${logfile}
echo "Status: Cleaning up after the ZeroTier installer" >> $deplog
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/ZT.pkg
sleep 1

echo "Command: DeterminateManualStep: 1" >> $deplog

# Kill off the ZeroTier.app and then ZeroTier auth copy processes as the mdm root user manages network join
echo "Status: Killing Processes" >> ${logfile}
echo "Killing Processes"

appPID=$(ps aux | grep 'ZeroTier' | grep -v 'grep' | grep -v 'security' | awk '{print$2}')
authPID=$(ps aux | grep 'ZeroTier' | grep 'security' | grep -v 'grep' | awk '{print$2}');

IFS=$'\n'
if [ -z "$appPID" ]
then
      echo No ZT App Processes Found
else
echo ZT Processes Found. Killing...
for item in $appPID
do
  pkill $item
  echo $item
done
fi

if [ -z "$authPID" ]
then
      echo No ZT Security Processes Found
else
echo ZT Security Processes Found. Killing...
for item in $authPID
do
  pkill $item
  echo $item
done
fi


#This sleep is functional and is needed to allow the processes to close properly before reopening the application
sleep 5

# echo "Status: Joining ZeroTier to network ${@}" >> ${logfile}
# echo "Status: Joining ZeroTier to network ${@}" >> ${deplog}
# /usr/local/bin/zerotier-cli join $@

exit 0
