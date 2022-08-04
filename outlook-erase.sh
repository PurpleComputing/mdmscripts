#!/bin/sh
#########################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   Outlook Erase Tool
#
# SYNOPSIS
# outlook-erase.sh
# FOR INITIAL DEPLOYMENT OR ENROLMENT USE ONLY
#########################################################################
#
# HISTORY
#
#   Version: 1.3
#
#   - 1.0 04.08.22 Michael Tanner, Initial Script Template Build
#
#########################################################################

scriptver='1.0'
logfile="/Library/Logs/com.purplecomputing.mdm/outlook-erase.log"
#Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Logs/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/

curl -o /Library/Caches/com.purplecomputing.mdm/Apps/OE.pkg https://office-reset.com/download/Microsoft_Outlook_Data_Removal_1.9.1.pkg

echo "Status: Running the installer" >> ${logfile}
installer -pkg /Library/Caches/com.purplecomputing.mdm/Apps/OE.pkg -target /

echo "Status: Cleaning up after the installer" >> ${logfile}
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/OE.pkg
sleep 2

echo "Status: Completed" >> ${logfile}
echo Complere

exit 0
