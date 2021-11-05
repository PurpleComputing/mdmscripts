# Custom Command Template / Script Template
```
##  PURPLE GITHUB PULL TEMPLATE  ##
##-------------------------------##
##        SET PERMISSIONS        ##
chmod 777 -R /tmp
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
rm -rf /tmp/$SCRIPTNAME
rm -rf /tmp/brandDEPinstall.sh

# REMOVE APPS AND FILES
killall $appname
rm -rf /Applications/$appname.app

##-------------------------------##
##       DEPNOTIFY WINDOW        ##
##-------------------------------##

# SET APP TITLE TO APPNAME
echo $appname >> /tmp/.appinstallname

# SET DEP NOTIFY FOR REINSTALL
curl -o /tmp/brandDEPinstall.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/brandDEPinstall.sh
chmod +x /tmp/brandDEPinstall.sh
/tmp/brandDEPinstall.sh
sleep 2s
chmod 777 /var/tmp/depnotify.log

# START DEPNOTIFY
sudo -u %LastConsoleUser% /Library/Application\ Support/Purple/launch-dep.sh

##-------------------------------##
##         START SCRIPT          ##
##-------------------------------##

# DOWNLOAD LATEST FILE
curl -o /tmp/$SCRIPTNAME https://raw.githubusercontent.com/PurpleComputing/$REPO/$BRANCH/$SCRIPTNAME
# GIVE EXECUTE PERMISSIONS
sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'END'
chmod +x /tmp/$SCRIPTNAME
# RUN AS CURRENT USER
/tmp/$SCRIPTNAME >> /tmp/$SCRIPTNAME.log

##-------------------------------##
##       DEPNOTIFY CLOSE         ##
##-------------------------------##

# CLOSE DEP NOTIFY WINDOW
echo Status: $appname Install Complete >> /var/tmp/depnotify.log
sleep 10s
killall DEPNotify

##-------------------------------##
##      POSTFLIGHT SCRIPT        ##
##-------------------------------##

rm -rf /tmp/$scriptfilename
rm -rf /tmp/.appinstallname
rm -rf /tmp/brandDEPinstall.sh

# END SCRIPT WITH SUCCESS
exit 0

```

