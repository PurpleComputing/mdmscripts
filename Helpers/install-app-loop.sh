#!/bin/zsh
# install-app-loop.sh

# SERVICE SCRIPT CALLED BY OTHER SCRIPTS

prplappno=
prplappcount=

echo "*** BEGIN install-app-loop.SH ***"
chmod 777 /var/tmp/depnotify.log
######################################################################
# Installation using Installomator (enter the software to install separated with spaces in the "whatList"-variable)
LOGO="mosyleb" # or "mosylem"
######################################################################

whatList="$MDMAPPLABEL"
echo "$MDMAPPLABEL"

# CHECKS IF INSTALLOMATOR IS INSTALLED AND INSTALLS IF NOT
if [ ! -e "/usr/local/Installomator/Installomator.sh" ]; then
	curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Installomator.sh?v=123$(date +%s) | bash
fi

# No sleeping
/usr/bin/caffeinate -d -i -m -u &
caffeinatepid=$!
caffexit () {
	kill "$caffeinatepid"
	pkill caffeinate
	exit $1
}
# Mark: Start Installomator label(s) installation
# Count errors
errorCount=0

echo "Command: DeterminateOff:" >> /var/tmp/depnotify.log
echo "Command: DeterminateOffReset:" >> /var/tmp/depnotify.log
prplappno=$(echo "$whatList" | awk '{print gsub("[ \t]",""); exit}')
prplappcount=`expr $prplappno + 4`
prpltrueappcount=`expr $prplappno + 1`
echo "Command: DeterminateManual: $prplappcount" >> /var/tmp/depnotify.log
echo "-- INSTALLING $prpltrueappcount APPS --"
echo Installs started for "$MDMAPPLABEL"
# Verify that Installomator has been installed
destFile="/usr/local/Installomator/Installomator.sh"
if [ ! -e "${destFile}" ]; then
	echo "Installomator not found here:"
	echo "${destFile}"
	echo "Exiting."
	caffexit 99
fi
echo Started Installomator
for what in $whatList; do
	echo Installing ${what}
	TMAPPNA$(sed -n "/${what}/,\$p" /usr/local/Installomator/Installomator.sh  | sed -n 2p)
	$TMAPPNA
	echo "Status: installing $name" >> /var/tmp/depnotify.log
	echo "Command: DeterminateManualStep: 1" >> /var/tmp/depnotify.log
	# Install software using Installomator
	cmdOutput="$(${destFile} ${what} LOGO=$LOGO NOTIFY=all BLOCKING_PROCESS_ACTION=kill || true)" # NOTIFY=silent BLOCKING_PROCESS_ACTION=quit_kill INSTALL=force
	# Check result
	echo "Status: installer for $name complete..." >> /var/tmp/depnotify.log
	sleep 1
	exitStatus="$( echo "${cmdOutput}" | grep --binary-files=text -i "exit" | tail -1 | sed -E 's/.*exit code ([0-9]).*/\1/g' || true )"
	if [[ ${exitStatus} -ne 0 ]] ; then
		echo "Error installing ${what}. Exit code ${exitStatus}"
		echo "Status: error installing $name" >> /var/tmp/depnotify.log
		#echo "$cmdOutput"
		errorOutput="$( echo "${cmdOutput}" | grep --binary-files=text -i "error" || true )"
		echo "$errorOutput"
		let errorCount++
	fi
done
echo Finished Installomator
echo
echo "Errors: $errorCount"
echo
echo "[$(DATE)][LOG-END]"

caffexit $errorCount
echo "*** END install-app-loop.SH ***"