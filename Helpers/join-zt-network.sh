################################################################################################
#
#                                                        ******      
#                                        *...../    /    ******               
# **************  *****/  *****/*****/***/*************/ ******  /**********      
# ******/..*****/ *****/  *****/********//******/ ,*****/******,*****  ,*****/    
# *****/    ***** *****/  *****/*****/    *****/   /**************************    
# *******//*****/ *************/*****/    *********************/*******./*/*  ())
# *************    ******/*****/*****/    *****/******/. ******   ********** (()))
# *****/                                  *****/                              ())
# *****/                                  *****/                                  
#
################################################################################################
# NOTICE: MAC SPECIFIC SCRIPT, USING MOSYLE VARIABLES
################################################################################################

#  PURPLE GITHUB PULL TEMPLATE  ##
##-------------------------------##
##-------------------------------##
##         SET VARIABLES         ##

NETNAME="$1"
LOGLOCAL=/Library/Logs/com.purplecomputing.mdm/
NETID="$2"
APIKEY="$3"


echo NET NAME $NETNAME
echo NET ID $NETID
echo API KEY $APIKEY
##-------------------------------##
##       PREFLIGHT SCRIPT        ##
##-------------------------------##

# CLEAN UP PREVIOUS FILES
mkdir -p /Library/Caches/com.purplecomputing.mdm/Scripts/
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/pkg
rm -rf /tmp/ztnetauthed.log /tmp/ztnetready.log  /tmp/ztnetjoined.log


# UPDATE PURPLE HELPERS
curl -o /tmp/purple-helpers.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/purple-helpers.sh
chmod +x /tmp/purple-helpers.sh
/tmp/purple-helpers.sh
sleep 2
rm -rf /tmp/purple-helpers.sh


##-------------------------------##
##         START SCRIPT          ##
##-------------------------------##
echo Status: Joining $NETNAME Network >> /var/tmp/depnotify.log
sudo -u $(stat -f "%Su" /dev/console) /usr/local/bin/zerotier-cli join $NETID
/usr/local/bin/zerotier-cli join $NETID
touch /tmp/ztnetjoined.log
sleep 3
#
########################################################################
#
#
#
MYID=$(/usr/local/bin/zerotier-cli info | cut -d " " -f 3)
echo Status: Authorising your Node... >> /var/tmp/depnotify.log

sleep 3
#
#    CALL API WITH INFO
#
echo BEFORE CURL
curl -H "Authorization: Bearer $APIKEY" -X POST -d '{"name":"'"%DeviceName%"'","description":"Device authorised through Purple Script.","config":{"authorized":true}}' https://my.zerotier.com/api/network/$NETID/member/$MYID
curl -s -H "Authorization: Bearer $APIKEY" https://my.zerotier.com/api/network/$NETID/member/$MYID
echo Status: Network authorised, ready to go! >> /var/tmp/depnotify.log
touch /tmp/ztnetauthed.log
echo AFTER CURL
#
echo Command: ContinueButton: Close >> /var/tmp/depnotify.log

sleep 10
touch /tmp/ztnetready.log
killall DEPNotify
rm -rf /var/tmp/depnotify.log
touch /var/tmp/depnotify.log
chmod 777 /var/tmp/depnotify.log
exit 0
