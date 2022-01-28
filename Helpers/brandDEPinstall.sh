#!/bin/sh
#########################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   DEPNotify Branding for app installs
#
# SYNOPSIS
# brandDEPinstall.sh
# FOR INITIAL DEPLOYMENT OR ENROLMENT USE ONLY
#########################################################################
#
# HISTORY
#
#   Version: 1.3
#
#   - 1.1 Michael Tanner, 04.10.2021
#   - 1.2 Michael Tanner, 04.10.2021
#   - 1.3 Michael Tanner, 04.10.2021 - Fixed moved /tmp location for $appname
#
#########################################################################
# Script to brand DEPNotify with PurpleComputing for app installs.
#
cp -f /tmp/.appinstallname /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname
rm /tmp/.appinstallname
appname=$(cat /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname)
chmod 777 /var/tmp/depnotify.log

## BRANDING DEPNOTIFY WINDOW
echo Command: MainTitle: Installing $appname... >> /var/tmp/depnotify.log
echo 'Command: Image: /Library/Application Support/Purple/logo.png' >> /var/tmp/depnotify.log
echo Command: MainText: We are now installing the $appname application. >> /var/tmp/depnotify.log
echo Command: WindowStyle: Activate >> /var/tmp/depnotify.log

if @1 != "NotificationOff" then
echo Command: NotificationOn: >> /var/tmp/depnotify.log
fi
    
done
## STARTING INSTALLS ###
sleep 2
## echo Status: Installing $appname in the background... >> /var/tmp/depnotify.log ## IGNORE DO NOT DELETE FOR NOW
