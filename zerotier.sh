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
#   Version: 1.2
#
#   - 1.0 Martyn Watts, 25.06.2021 Initial Script Template Build
#   - 1.1 Michael Tanner, 28.09.2021 Implement ZeroTier Install Script
#   - 1.2 Martyn Watts, 29.09.2021 Added logging information
#
#########################################################################
# Script to install ZeroTier and to join the organisations ZT Network.
#
scriptver='1.2'
logfile="/Library/Logs/ZeroTierInstallScript.log"
appName="ZeroTier"

echo "Status: Installing ${appName} using script version ${scriptver}" >> ${deplog}
echo "Status: Installing ${appName} using script version ${scriptver}" >> ${logfile}

echo "Status: Downloading ZeroTier" >> ${logfile}
echo "Status: Downloading ZeroTier" >> ${deplog}
curl -o /tmp/apps/ZT.pkg https://download.zerotier.com/dist/ZeroTier%20One.pkg

echo "Status: Running the installer" >> ${logfile}
echo "Status: Running the installer" >> ${deplog}
installer -pkg /tmp/apps/ZT.pkg -target /

echo "Status: Cleaning up after the installer" >> ${logfile}
echo "Status: Cleaning up after the installer" >> ${deplog}
rm -rf /tmp/apps/ZT.pkg
sleep 2s

echo "Status: Joining ZeroTier to network ${@}" >> ${logfile}
echo "Status: Joining ZeroTier to network ${@}" >> ${deplog}
/usr/local/bin/zerotier-cli join $@

exit 0