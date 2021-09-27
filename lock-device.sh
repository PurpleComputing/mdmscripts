#!/bin/sh

jssUser=$4
jssPass=$5
jssHost=$6
passcode=$7

id=$(jamf recon | grep '<computer_id>' | xmllint --xpath xmllint --xpath '/computer_id/text()' -)
/usr/bin/curl -su "${jssUser}:${jssPass}" "https://${jssHost}/JSSResource/computercommands/command/DeviceLock/passcode/${passcode}/id/${id}" -H "Content-Type: application/xml" -X POST
