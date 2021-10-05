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
appname=$(cat /tmp/.appinstallname)
chmod 777 /var/tmp/depnotify.log

## BRANDING DEPNOTIFY WINDOW
echo Command: MainTitle: Installing $appname... >> /var/tmp/depnotify.log
echo 'Command: Image: /Library/Application Support/Purple/logo.png' >> /var/tmp/depnotify.log
echo Command: MainText: We are now installing re-installing the $appname application. >> /var/tmp/depnotify.log
echo Command: WindowStyle: Activate >> /var/tmp/depnotify.log

## STARTING INSTALLS ###
sleep 3s
echo Status: Installing $appname in the background... >> /var/tmp/depnotify.log
