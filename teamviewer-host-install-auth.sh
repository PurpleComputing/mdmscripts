##  PURPLE CUSTOMCOMMAND TEMPLATE  ##
##-------------------------------##
##-------------------------------##
##         SET VARIABLES         ##

APPNAME='TeamViewer'
TVCOMPUTERGROUP="Group Name from TeamViewer Computers & Contacts"
TVAPITOPKEN="00000000-aaabbbcccdddeeefff"
TVPKGCODE="" # CODE FROM THE URL AS PER HERE https://dl.tvcdn.de/download/version_15x/CustomDesign/Install%20TeamViewerHost-[[TVPKGCODE]].pkg
TVCOMPUTERNAME="%LastConsoleUser%-%ProductName%"
##-------------------------------##
##          RUN SCRIPT           ##
##-------------------------------##

cd /tmp
cat << EOF > choices.xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array> <dict> <key>attributeSetting</key> <integer>1</integer> <key>choiceAttribute</key> <string>selected</string> <key>choiceIdentifier</key> <string>com.teamviewer.teamviewerhostSilentInstaller</string> </dict>
</array>
</plist>
EOF

killall TeamViewer

rm -rf /Applications/TeamViewer*

curl -L https://dl.tvcdn.de/download/version_15x/CustomDesign/Install%20TeamViewerHost-$TVPKGCODE.pkg -o Install%20TeamViewerHost-$TVPKGCODE.pkg
installer -applyChoiceChangesXML choices.xml -pkg Install%20TeamViewerHost-$TVPKGCODE.pkg -target /

echo "10 seconds wait"
sleep 10
echo "Assigning TeamViewer Device to our Account..." >> /var/tmp/depnotify.log
echo "Running the account assignment"

sudo /Applications/TeamViewerHost.app/Contents/Helpers/TeamViewer_Assignment -api-token $TVAPITOKEN -alias $TVCOMPUTERNAME -group $TVCOMPUTERGROUP -grant-easy-access
sleep 5

# END SCRIPT WITH SUCCESS
exit 0
