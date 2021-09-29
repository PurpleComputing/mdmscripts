#!/bin/sh
# Test
jssUser=$4
jssPass=$5
jssHost=$6

serial=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}')

username=$(/usr/bin/curl -H "Accept: text/xml" -sfku "${jssUser}:${jssPass}" "${jssHost}/JSSResource/computers/serialnumber/${serial}/subset/location" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<real_name>/{print $3}')

if [ "$username" == "" ]; then
    echo "Error: Username field is blank."
    exit 1

else
username="${username// /-}"
type=$(sysctl -n hw.model | cut -d "," -f 1 | tr -d '[0-9]_')
mac=$(networksetup -getmacaddress Wi-Fi | awk '{ field = substr($3,10,8) }; END{ print field }' | sed s/://g)
computerName="${username}-${type}-${mac}"

/usr/sbin/scutil --set HostName "$computerName"
/usr/sbin/scutil --set LocalHostName "$computerName"
/usr/sbin/scutil --set ComputerName "$computerName"

fi
