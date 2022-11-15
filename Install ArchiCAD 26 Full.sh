#!/bin/bash
##-------------------------------##
##    PURPLE ARCHICAD INSTALL    ##
##-------------------------------##
##-------------------------------##
##         SET VARIABLES         ##
##-------------------------------##

rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname
rm -rf /var/tmp/depnotify.log
touch /var/tmp/depnotify.log
chmod 777 /var/tmp/depnotify.log

APPNAME="ArchiCAD 26 Full"
LOGLOCAL=/Library/Logs/com.purplecomputing.mdm/ArchiCAD.26.Full.log
LOGFILE=/Library/Caches/com.purplecomputing.mdm/Logs/"$APPNAME".log
##-------------------------------##
##       PREFLIGHT SCRIPT        ##
##-------------------------------##

export CURL_SSL_BACKEND="secure-transport"

# CLEAN UP PREVIOUS FILES
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/$SCRIPTNAME
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/pkg

# REMOVE APPS AND FILES
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/Installomator.sh

# UPDATE PURPLE HELPERS
curl -o /tmp/purple-helpers.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/purple-helpers.sh
chmod +x /tmp/purple-helpers.sh
/tmp/purple-helpers.sh
sleep 2
rm -rf /tmp/purple-helpers.sh

rm -rf "/Library/Application Support/UAM/"
sleep 3
mkdir -p /Library/Caches/com.purplecomputing.mdm/Scripts/
mkdir -p '/Library/Application Support/UAM/'
chmod -R 777 "/Library/Application Support/UAM/"

##-------------------------------##
##       DEPNOTIFY WINDOW        ##
##-------------------------------##

# SET APP TITLE TO APPNAME
echo "$APPNAME" >> /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname

# SET DEP NOTIFY FOR REINSTALL
curl -o /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/brandDEPinstall.sh
chmod +x /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh
/Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh >> /Library/Logs/com.purplecomputing.mdm/brandDEPinstall.log
sleep 2
chmod 777 /var/tmp/depnotify.log
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh

# START DEPNOTIFY
echo Command: MainTitle: Requested $APPNAME... >> /var/tmp/depnotify.log
echo "Command: MainText: You have requested that we install $APPNAME. As this is a large installer the download may take a little while." >> /var/tmp/depnotify.log
/Library/Application\ Support/Purple/launch-dep.sh
echo Status: "$APPNAME" Install or Update Started >> /var/tmp/depnotify.log

##-------------------------------##
##-------------------------------##
##         START SCRIPT          ##
##-------------------------------##
##-------------------------------##
echo Status: "Downloading $APPNAME, this may take some time..." >> /var/tmp/depnotify.log
echo "Command: MainText: The download for $APPNAME has started. Please bear with us, this may take a little while." >> /var/tmp/depnotify.log

echo Command: MainTitle: Downloading $APPNAME... >> /var/tmp/depnotify.log
sleep 3
cd "/Library/Caches/com.purplecomputing.mdm/Apps/"

/usr/bin/curl -L "https://gsdownloads-cdn.azureedge.net/cdn/AC/26/INT/Archicad-26-INT-3001-1.1-INTEL.dmg" -o "/Library/Caches/com.purplecomputing.mdm/Apps/ARCHICAD26Full.dmg" 2>&1 | tee -a "$LOGFILE" &

# GET DOWNLOAD PROGRESS INTO DEPnotify
 echo "Command: DeterminateManual: 100" >> /var/tmp/depnotify.log
        until [[ $current_progress_value -ge 100 ]]; do
            until [[ $current_progress_value -gt $last_progress_value ]]; do
                current_progress_value=$(tail -1 "$LOGFILE" | tr '\r' '\n' | awk 'END{print substr($1,1,3)}')
                sleep 2
                done
            echo "Command: DeterminateManualStep: $((current_progress_value-last_progress_value))" >> /var/tmp/depnotify.log
            echo "Status: Downloading Installer - $current_progress_value%" >> /var/tmp/depnotify.log
            last_progress_value=$current_progress_value
            done
echo Command: DeterminateOff: >> /var/tmp/depnotify.log
echo Command: DeterminateOffReset: >> /var/tmp/depnotify.log 


sleep 3
#
echo "Command: DeterminateManual: 6" >> /var/tmp/depnotify.log
#
#
echo Status: "Decompressing $APPNAME ..." >> /var/tmp/depnotify.log
echo "Command: DeterminateManualStep: 1" >> /var/tmp/depnotify.log
#
cd "/Library/Caches/com.purplecomputing.mdm/Apps/"
/usr/bin/hdiutil attach /Library/Caches/com.purplecomputing.mdm/Apps/ARCHICAD26Full.dmg -nobrowse -quiet

#
echo Command: MainTitle: Installing $APPNAME... >> /var/tmp/depnotify.log
echo "Command: MainText: We're now installing $APPNAME this process is usually much quicker than the download." >> /var/tmp/depnotify.log

echo Status: "Installing $APPNAME ..." >> /var/tmp/depnotify.log
echo "Command: DeterminateManualStep: 1" >> /var/tmp/depnotify.log
cd /Volumes/Archicad\ 26/
cd Archicad*
./Contents/MacOS/osx-x86_64 --mode unattended

# /Volumes/Archicad\ 26/ARCHICAD\ Installer.app/Contents/MacOS/osx-x86_64 --mode unattended

#JH EDIT - COMMENT OUT UPDATE - DOES NOT EXIST
#echo Status: "Installing $APPNAME Update ..." >> /var/tmp/depnotify.log
#echo "Command: DeterminateManualStep: 1" >> /var/tmp/depnotify.log
#cd /Volumes/Archicad\ 26\ Solo\ Update*
#cd Archicad-26-Solo-UKI*
#./Contents/MacOS/osx-x86_64 --mode unattended

cd /tmp
# /Volumes/Archicad\ 26\ Solo\ Update\ \(7001\)/ARCHICAD-26-Solo-UKI-Update-7001-1.0-INTEL.app/Contents/MacOS/osx-x86_64 --mode unattended

sleep 5
#
echo Status: "Cleaning up files $APPNAME ..." >> /var/tmp/depnotify.log
echo "Command: DeterminateManualStep: 1" >> /var/tmp/depnotify.log
/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep Archicad | awk '{print $1}') -quiet
#JH EDIT /usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep Archicad | awk '{print $1}') -quiet
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/ARCHICAD26Full.dmg
#
/bin/echo "`date`: Cleaning up files..."  >> $LOGLOCAL
echo "Command: DeterminateManualStep: 1" >> /var/tmp/depnotify.log
#
#
echo Status: "Installed $APPNAME..." >> /var/tmp/depnotify.log
echo "Command: DeterminateManualStep: 1" >> /var/tmp/depnotify.log

#echo "Command: MainText: We have installed $APPNAME successfully." >> /var/tmp/depnotify.log

##-------------------------------##
##-------------------------------##
##         END SCRIPT            ##
##-------------------------------##
##-------------------------------##

##-------------------------------##
##       DEPNOTIFY CLOSE         ##
##-------------------------------##

# CLOSE DEP NOTIFY WINDOW
sleep 10
echo Command: MainTitle: Installed $APPNAME >> /var/tmp/depnotify.log
echo "Command: MainText: All done. $APPNAME is now installed and patched." >> /var/tmp/depnotify.log

echo Status: Install Complete. Thank you for choosing Purple Computing... >> /var/tmp/depnotify.log
echo "Command: ContinueButton: Close" >> /var/tmp/depnotify.log

#JH EDIT /usr/local/bin/dockutil --add "/Applications/Graphisoft/Archicad 26 Solo/Archicad 26.app" --position end --no-restart --allhomes
#JH EDIT killall Dock
##-------------------------------##
##      POSTFLIGHT SCRIPT        ##
##-------------------------------##

rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname
rm -rf /var/tmp/depnotify.log
touch /var/tmp/depnotify.log
chmod 777 /var/tmp/depnotify.log

# END SCRIPT WITH SUCCESS
exit 0