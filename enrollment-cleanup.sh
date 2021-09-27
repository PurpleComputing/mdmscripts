#!/bin/bash
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   EnrollmentProcessCleanUp.sh -- Removes the enrollmentProfile from downloads folder if present and then kill Safari
#
# SYNOPSIS
#   sudo EnrollmentProcessCleanUp.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.1
#
#   - v.1.0 Martyn Watts, 05.07.2021 - Initial Build
#	- v.1.1 Martyn Watts, 07.07.2021 - Added the process to kill off safari to ensure that it doesn't interfere with Acrobat install
#   - v.1.2 Martyn Watts, 08.07.2021 - Added DEPNotify Updates
#
#
####################################################################################################
deplog="/var/tmp/depnotify.log"

/bin/echo "Status: Cleaning up the Enrollment Process" >> ${deplog}
sleep 2

loggedInUser=$( echo "show State:/Users/ConsoleUser" | /usr/sbin/scutil | /usr/bin/awk '/Name :/ && ! /loginwindow/ { print $3 }' )
fileLocation="/Users/${loggedInUser}/Downloads/enrollmentProfile.mobileconfig"

logfile="/Library/Logs/EnrollmentProcessCleanUp.log"

        /bin/echo "`date`: Forcing Safari to quit if open" >> ${logfile}
        /bin/echo "Status: Forcing Safari to quit if open" >> ${deplog}
        /bin/echo "Forcing Safari to quit if open"
		killall Safari
		
        /bin/echo "`date`: Closing System Preferences if open" >> ${logfile}
        /bin/echo "Status: Closing System Preferences if open" >> ${deplog}
        /bin/echo "Closing System Preferences if open"		

osascript <<EOD
if application "System Preferences" is running then
 tell application "System Preferences" to quit
end if
EOD

    if [[ -e "${fileLocation}" ]]; then
        /bin/echo "${fileLocation} found - Deleting"
        /bin/echo "Status: ${fileLocation} found - Deleting" >> ${deplog}
        /bin/echo "`date`: ${fileLocation} found - Deleting" >> ${logfile}
        /bin/rm -rf "${fileLocation}"
        /bin/echo "--" >> ${logfile}
    else
        /bin/echo "${fileLocation} not present - Exiting"
        /bin/echo "Status: ${fileLocation} not present - Exiting" >> ${deplog}
        /bin/echo "`date`: ${fileLocation} not present - Exiting" >> ${logfile}
        /bin/echo "--" >> ${logfile}
    fi
    
        /bin/echo "Command: DeterminateManualStep: 1" >> ${deplog}
exit 0
