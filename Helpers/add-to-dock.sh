#!/bin/zsh
# add-to-dock.sh

# SERVICE SCRIPT CALLED BY OTHER SCRIPTS

prplappno=
prplappcount=

echo "*** BEGIN add-to-dock.SH ***"
chmod 777 /var/tmp/depnotify.log

whatDockList=$MDMAPPLABEL # RECEIVES VARIABLE FROM ENV
echo
echo THE BELOW ERROR IS NORMAL
while read line >> /dev/null
do
  echo "$line"
done < "${1:-/dev/stdin}"
echo PLEASE IGNORE ABOVE ERROR
echo
# No sleeping keep device awake
/usr/bin/caffeinate -d -i -m -u &
caffeinatepid=$!
caffexit () {
	kill "$caffeinatepid"
	pkill caffeinate
	exit $1
}

# Count errors
errorCount=0
# Count dock items 
prplappno=$(echo "$whatDockList" | awk '{print gsub("[ \t]",""); exit}')
prplappcount=`expr $prplappno + 4`
prpltrueappcount=`expr $prplappno + 1`
echo "-- ADDING $prpltrueappcount APPS TO DOCK --"
echo Dock will appear in this order "$@"

# Verify that DockUtil has been installed, exit script and record error if not
dockdestFile="/usr/local/bin/dockutil"
if [ ! -e "${dockdestFile}" ]; then
	echo "DockUtil not found here:"
	echo "${dockdestFile}"
	echo "Exiting."
	caffexit 99
fi

#EMPTYDOCK - not used in this script
# /usr/local/bin/dockutil --remove all --allhomes

rm -rf /usr/local/bin/dockutil-labels.sh
curl -s -o /usr/local/bin/dockutil-labels.sh https://raw.githubusercontent.com/PurpleComputing/helpful-scripts/main/dockutil-labels.sh
chmod +x /usr/local/bin/dockutil-labels.sh


dockdestFile="/usr/local/bin/dockutil-labels.sh"


echo Started Dock Add Script
for what in $whatDockList; do
	echo Running Dock Add for ${what}
	
	# Looping using dockutil-labels.sh
	cmdOutput="$(${dockdestFile} ${what} || true)"
	# Check result
	echo "Status: Dock addition for ${what} complete..." >> /var/tmp/depnotify.log
	sleep 1
	exitStatus="$( echo "${cmdOutput}" | grep --binary-files=text -i "exit" | tail -1 | sed -E 's/.*exit code ([0-9]).*/\1/g' || true )"
	if [[ ${exitStatus} -ne 0 ]] ; then
		echo "Error adding dock item ${what}. Exit code ${exitStatus}"
		echo "Status: error adding ${what} to dock" >> /var/tmp/depnotify.log
		#echo "$cmdOutput"
		errorOutput="$( echo "${cmdOutput}" | grep --binary-files=text -i "error" || true )"
		echo "$errorOutput"
		let errorCount++
	fi
done
echo Finished Dock Add Script
echo
echo "Errors: $errorCount"
echo
echo "[$(DATE)][LOG-END]"

echo "Command: DeterminateManualStep: 1" >> /var/tmp/depnotify.log

caffexit $errorCount
echo "*** END add-to-dock.SH ***"