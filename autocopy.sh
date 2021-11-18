#!/bin/bash

PIDFILE=/home/pi/autocopy.pid
SOURCE="/media/pi/C709-4E67"
TARGET_ROOT="tomklaasen@backupmini.local:/media/usb1/virb" 


if [ -f $PIDFILE ]
then
  PID=$(cat $PIDFILE)
  ps -p $PID > /dev/null 2>&1
  if [ $? -eq 0 ]
  then
    # echo "Process already running"
    exit 1
  else
    ## Process not found assume not running
    echo $$ > $PIDFILE
    if [ $? -ne 0 ]
    then
      # echo "Could not create PID file"
      exit 1
    fi
  fi
else
  echo $$ > $PIDFILE
  if [ $? -ne 0 ]
  then
    # echo "Could not create PID file"
    exit 1
  fi
fi


if [ -d "$SOURCE" ]; then
  # Take action if $SOURCE exists. #
  # echo "${SOURCE} exists..."
  if [ "$(ls -A $SOURCE/DCIM/102_VIRB)" ]; then
      TARGET="$TARGET_ROOT/virb-export"
      rsync -avzh --remove-source-files "$SOURCE/DCIM/102_VIRB/" "$TARGET/DCIM/102_VIRB"
      rsync -avzh --remove-source-files "$SOURCE/GMetrix/" "$TARGET/GMetrix"
  fi
fi


rm $PIDFILE
