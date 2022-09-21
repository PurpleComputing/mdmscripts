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
#   Version: 1.4
#
#   - 1.1 Michael Tanner, 04.10.2021
#   - 1.2 Michael Tanner, 04.10.2021
#   - 1.3 Michael Tanner, 04.10.2021 - Fixed moved /tmp location for $appname
#   - 1.4 Michael Tanner, 04.10.2021 - Removed IF statement
#
#########################################################################
# Script to brand DEPNotify with PurpleComputing for app installs.

# SERVICE SCRIPT CALLED BY OTHER SCRIPTS

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

## STARTING INSTALLS ###
sleep 1 