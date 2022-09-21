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
curl -s -o /Library/Application\ Support/Purple/swda.zip https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/swda.zip
unzip swda.zip
sleep 3
rm swda.zip
xattr -r -d com.apple.quarantine /Library/Application\ Support/Purple/swda
ln -s /Library/Application\ Support/Purple/swda /usr/local/bin/swda
