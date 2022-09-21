#!/bin/sh
# echo "*** PURPLE SWDA DEPLOY SCRIPT ***"
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
# SWIFT DEFAULT APPS DEPLOYMENT SCRIPT
################################################################################################


cd /Library/Application\ Support/Purple/
rm -rf _MACOSX
curl -s -o /Library/Application\ Support/Purple/swda.zip https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/swda.zip
unzip swda.zip
sleep 3
rm swda.zip _MACOSX

xattr -r -d com.apple.quarantine /Library/Application\ Support/Purple/swda

if [ ! -e "/usr/local/bin/swda" ]; then
	ln -s /Library/Application\ Support/Purple/swda /usr/local/bin/swda
fi

