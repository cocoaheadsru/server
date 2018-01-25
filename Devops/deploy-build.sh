#!/bin/bash
# CocoaHeadsRu (c) 
# Description: this is the shell script for the cocoaheadsru server deploy and start 
# Author:  Dmitry, ditansu@gmail.com


##SETINGS
#Get from Jenkins  pipeline 

PROJECT=$CH_BUILD   
WEBROOT=$CH_WEBROOT 

#Permisions 
USER="www-data"
GROUP="www-data"

#Commands 
SUPERVISOR=/usr/bin/supervisorctl
SERVICE="cocoaheadsru"

##WORK
echo "Stop $SERVICE..."
$SUPERVISOR stop $SERVICE

rm -rf $WEBROOT/server.bak
mv -f $WEBROOT/server  $WEBROOT/server.bak 

echo "Copy $PROJECT to $WEBROOT"
cp -r $PROJECT $WEBROOT/server 
echo "Chown $USER:$GROUP for $WEBROOT" 
chown -fR $USER:$GROUP $WEBROOT

echo "Start $SERVICE..."

RESULT=$($SUPERVISOR start $SERVICE)
echo ""
echo "Result is $RESULT"
echo ""

if [[ $RESULT == *"ERROR"* ]]; then 	
  echo "Something was wrong, let try start to rollback deploy..."
  # set variable for Pipeline 
  DEPLOY_STATUS="FAILURE"
  exit 0
fi
exit 0

