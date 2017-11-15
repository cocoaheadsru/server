#!/bin/bash
# CocoaHeads Ru
# Description: this is the shell script for the cocoaheadsru server deploy and start 
# Author:  Dmitry, ditansu@gmail.com


##SETINGS

#Paths 

#get from Jankins   pipeline
WEBROOT=$CH_WEBROOT 

#Commands 
SUPERVISOR=/usr/bin/supervisorctl
SERVICE="cocoaheadsru"

##WORK

if [ ! -d "$WEBROOT/server.bak" ]; then
  echo "$WEBROOT/server.bak is not exist!"
  echo "Unfortenately I can't rollback"
  exit 1
fi

echo "Recovering the backup from ${WEBROOT}/server.bak"
rm -rf $WEBROOT/server.error
mv -f $WEBROOT/server  $WEBROOT/server.error
rm -rf $WEBROOT/server
mv -f $WEBROOT/server.bak  $WEBROOT/server
echo "Restart supervisor"

echo "Try to start previos release $SERVICE..."
RESULT=$($SUPERVISOR restart $SERVICE)

if [[ $RESULT == *"ERROR"* ]]; then  
  echo "Unfortenately I've can't rollback"
  exit 1
fi

echo "Fine I could rollback and start previos build"
exit 0

