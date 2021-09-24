#!/bin/bash
###
# REDIRECTED TO NEW FILE
# Parameters can be found here: https://github.com/PurpleComputing/mdmscripts/blob/main/microsoft-apps.sh
###
echo Redirecting to newer script...
sudo curl -o /tmp/microsoft-apps.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/microsoft-apps.sh
sudo chmod /tmp/microsoft-apps.sh
echo Executing newer Microsoft Apps script...
sudo /tmp/microsoft-apps.sh $@
