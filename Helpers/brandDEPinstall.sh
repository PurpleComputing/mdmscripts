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
#   Version: 1.2
#
#   - 1.1 Michael Tanner, 04.10.2021
#
#########################################################################
# Script to brand DEPNotify with PurpleComputing for app installs.
#

## BRANDING DEPNOTIFY WINDOW
echo 'Command: MainTitle: Deploying your Mac' >> /var/tmp/depnotify.log
echo 'Command: Image: /Library/Application Support/Purple/logo.png' >> /var/tmp/depnotify.log
echo 'Command: MainText: Your organisation is using a Mobile Device Management solution provided by Purple Computing, we are now installing your organisations software, settings and policies.' >> /var/tmp/depnotify.log

## STARTING INSTALLS ###
echo 'Status: Starting MDM Installer' >> /var/tmp/depnotify.log
sleep 3s
#sudo -u $(stat -f '%Su' /dev/console) /bin/sh <<'END'
chmod 777 /var/tmp/depnotify.log
killall DEPNotify
/Applications/Utilities/DEPNotify.app/Contents/MacOS/DEPNotify
chmod 777 /var/tmp/depnotify.log
sleep 3s
echo 'Status: Starting Software Install' >> /var/tmp/depnotify.log
