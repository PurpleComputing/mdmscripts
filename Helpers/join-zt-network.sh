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

NETNAME='$1'
LOGLOCAL=/Library/Logs/com.purplecomputing.mdm/
NETID="$2"
APIKEY="$3"
##-------------------------------##
##       PREFLIGHT SCRIPT        ##
##-------------------------------##

# CLEAN UP PREVIOUS FILES
mkdir -p /Library/Caches/com.purplecomputing.mdm/Scripts/
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/pkg


# UPDATE PURPLE HELPERS
curl -o /tmp/purple-helpers.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/purple-helpers.sh
chmod +x /tmp/purple-helpers.sh
/tmp/purple-helpers.sh
sleep 2
rm -rf /tmp/purple-helpers.sh

##-------------------------------##
##       DEPNOTIFY WINDOW        ##
##-------------------------------##


# SET DEP NOTIFY FOR NET JOIN
curl -o /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/brandDEPinstall.sh
chmod +x /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh
/Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh >> /Library/Logs/com.purplecomputing.mdm/brandDEPinstall.log
sleep 2
chmod 777 /var/tmp/depnotify.log
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh

echo Command: MainTitle: Joining ZeroTier Network... >> /var/tmp/depnotify.log
echo 'Command: Image: /Library/Application Support/Purple/logo.png' >> /var/tmp/depnotify.log
echo "Command: MainText: We are now joining you to the $NETNAME ZT Network. Please Note, this script will approve your access in ZeroTier Admin so you do not need to log in." >> /var/tmp/depnotify.log
echo Command: WindowStyle: Activate >> /var/tmp/depnotify.log
echo "Command: Determinate: 3" >> /var/tmp/depnotify.log


##-------------------------------##
##         START SCRIPT          ##
##-------------------------------##
echo Status: Joining $NETNAME Network >> /var/tmp/depnotify.log
sudo -u $(stat -f "%Su" /dev/console) /usr/local/bin/zerotier-cli join $NETID
/usr/local/bin/zerotier-cli join $NETID
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
echo AFTER CURL
#
echo Command: ContinueButton: Close >> /var/tmp/depnotify.log

sleep 3
killall DEPNotify
rm -rf /var/tmp/depnotify.log
touch /var/tmp/depnotify.log
chmod 777 /var/tmp/depnotify.log
exit 0
