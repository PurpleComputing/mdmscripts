echo
echo

echo Self Service Version:
defaults read /Applications/Self-Service.app/Contents/Info CFBundleShortVersionString

echo
echo
#KERNELPANICS
PanicLogCount=$(/usr/bin/find /Library/Logs/DiagnosticReports -Btime -7 -name *.panic | grep . -c)
/bin/echo Kernel Panics Logged":" "$PanicLogCount"

echo
echo

#TEAMVIEWER
DIR0="/Library/Preferences/com.teamviewer.teamviewer.preferences.plist"
if [ -f "$DIR0" ]; then

	TVID=$(defaults read /Library/Preferences/com.teamviewer.teamviewer.preferences.plist ClientID)
	echo "TeamViewer ID: $TVID"
	
else

	echo "TeamViewer is not installed"
	
fi

echo
echo

#LAST INFO
REBOOT=$(last | grep -m 1 "reboot" | awk '{ print $3 " " $4 " " $5 " " $6 }')
SHUTDOWN=$(last | grep -m 1 "shutdown" | awk '{ print $3 " " $4 " " $5 " " $6 }')
LOGIN=$(last | grep -m 1 "console" | awk '{ print $1 " " $3 " " $4 " " $5 " " $6 }')
echo "Last Login: $LOGIN"
echo "Last Reboot: $REBOOT"
echo "Last Shutdown: $SHUTDOWN"

echo
echo

#Volumes
echo Volumes Mounted":"
cd /Volumes && ls
cd /tmp
echo
echo

#ZEROTIER
echo "ZeroTier Information"
DIR="/Library/Application Support/ZeroTier"
if [ -d "$DIR" ]; then
MYID=$(/usr/local/bin/zerotier-cli info | cut -d " " -f 3)
MYNET=$(/usr/local/bin/zerotier-cli listnetworks | cut -d " " -f 3 | sed -n 2p)
ZTALL=$(/usr/local/bin/zerotier-cli listnetworks | cut -d " " -f 3 | sed '/<nwid>/d')
echo "Node ID: $MYID"
echo "-"
# START LOOP
for i in $ZTALL
do
MYIP=$(/usr/local/bin/zerotier-cli get $i ip)
echo "Network Name:" $(/usr/local/bin/zerotier-cli get $i name)
echo "Node IP: $MYIP"
echo "Network ID:" "$i"
echo "-"
# END LOOP
done
else
  echo "ZeroTier is not installed"
fi
# exit 0

echo
echo

hwType=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Model Identifier" | grep "Book")

if [ "$hwType" != "" ];
  then
    batteryCondition=$(system_profiler SPPowerDataType | grep "Condition" | awk -F': ' '/Condition:/{ print $NF }')
    batteryCycleCount=$(system_profiler SPPowerDataType | grep "Cycle Count" | awk '{print $3}')
    echo Battery Health":" $batteryCondition \($batteryCycleCount\)
  else
	  echo Battery Health":" "N/A"
fi

echo
echo

# echo "Apple ID:"
# /usr/libexec/PlistBuddy -c "print :Accounts:0:AccountID" /Users/$(stat -f "%Su" /dev/console)/Library/Preferences/MobileMeAccounts.plist

echo
echo

echo Users:
dscl . list /Users | grep -v "^_"

echo
echo

echo Last Logins:
last -10

echo
echo

echo Uptime:
uptime

echo
echo

echo Printers:
lpstat -p | awk '{print $2}'

echo
echo
