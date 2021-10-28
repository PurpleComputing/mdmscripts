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
##-------------------------------##
##         START SCRIPT          ##
##-------------------------------##
# CLEAN UP PREVIOUS FILE
rm -rf /tmp/$SCRIPTNAME
# DOWNLOAD LATEST FILE
curl -o /tmp/$SCRIPTNAME https://raw.githubusercontent.com/PurpleComputing/$REPO/$BRANCH/$SCRIPTNAME
# GIVE EXECUTE PERMISSIONS
sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'END'
chmod +x /tmp/$SCRIPTNAME
# RUN AS CURRENT USER
/tmp/$SCRIPTNAME >> /tmp/$SCRIPTNAME.log
```