# Custom Command Template / Script Template
```
##  PURPLE GITHUB PULL TEMPLATE  ##
##-------------------------------##
##-------------------------------##
##         SET VARIABLES         ##

SCRIPTNAME=[[fix-outlook-spotlight.sh]]
REPO=[[troubleshooting]]
BRANCH=[[main]]
APPNAME='APPNAME'

##-------------------------------##
##       PREFLIGHT SCRIPT        ##
##-------------------------------##

# CLEAN UP PREVIOUS FILES
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/$SCRIPTNAME
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/.appinstallname

# REMOVE APPS AND FILES
killall $APPNAME
rm -rf /Applications/$APPNAME.app

# UPDATE PURPLE HELPERS
curl -o /Library/Caches/com.purplecomputing.mdm/Scripts/purple-helpers.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/purple-helpers.sh
chmod +x /Library/Caches/com.purplecomputing.mdm/Scripts/purple-helpers.sh
/Library/Caches/com.purplecomputing.mdm/Scripts/purple-helpers.sh >> /Library/Caches/com.purplecomputing.mdm/Logs/purple-helpers.log
sleep 2s
rm -rf purple-helpers.sh

##-------------------------------##
##       DEPNOTIFY WINDOW        ##
##-------------------------------##

# SET APP TITLE TO APPNAME
echo $APPNAME >> /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname

# SET DEP NOTIFY FOR REINSTALL
curl -o /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/brandDEPinstall.sh
chmod +x /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh
/Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh >> /Library/Caches/com.purplecomputing.mdm/Logs/brandDEPinstall.log
sleep 2s
chmod 777 /var/private/var/tmp/depnotify.log
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh

# START DEPNOTIFY
/Library/Application\ Support/Purple/launch-dep.sh

##-------------------------------##
##         START SCRIPT          ##
##-------------------------------##

# DOWNLOAD LATEST FILE
curl -o /Library/Caches/com.purplecomputing.mdm/Scripts/$SCRIPTNAME https://raw.githubusercontent.com/PurpleComputing/$REPO/$BRANCH/$SCRIPTNAME
# GIVE EXECUTE PERMISSIONS
chmod +x /Library/Caches/com.purplecomputing.mdm/Scripts/$SCRIPTNAME
# RUN AS CURRENT USER
sudo /Library/Caches/com.purplecomputing.mdm/Scripts/$SCRIPTNAME >> /Library/Caches/com.purplecomputing.mdm/Logs/$SCRIPTNAME.log

##-------------------------------##
##       DEPNOTIFY CLOSE         ##
##-------------------------------##

# CLOSE DEP NOTIFY WINDOW
echo Status: $APPNAME Install Complete >> /var/private/var/tmp/depnotify.log
sleep 10s
killall DEPNotify

##-------------------------------##
##      POSTFLIGHT SCRIPT        ##
##-------------------------------##

rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/$SCRIPTNAME
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname


# END SCRIPT WITH SUCCESS
exit 0

```

