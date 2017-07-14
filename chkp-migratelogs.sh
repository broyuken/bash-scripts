#!/bin/bash

# Verizon Migrate Archive Logs to Secondary Disk

# Author: Brian Roy

# Check Point Software Technologies

# Update 7/13/2017

 

#Variables

LOGLOCATION=/opt/CPsuite-R80/fw1/log

ARCHIVELOCATION=/tmp/archive

AGELIMIT=30

NUMBEROFLOGS=$(find $LOGLOCATION/ -maxdepth 1 -name *.log -mtime +$AGELIMIT -type f -exec echo "{}" \; | wc -l)

REDTEXT=`tput setaf 1`

RESETTEXT=`tput sgr0`

 

#Find Files older than $AGELIMIT days

if [ $NUMBEROFLOGS -gt 0 ]; then

  echo "${REDTEXT}LOG_MIGRATION_SCRIPT ${RESETTEXT}The Below Log Files are Older Than $AGELIMIT Days"

  LOGFILES=$(find $LOGLOCATION/ -maxdepth 1 -name *.log -mtime +$AGELIMIT -type f -exec echo "{}" \; | awk -F "/" '{print $(NF)}' )

  echo "$LOGFILES"

else

  echo "${REDTEXT}LOG_MIGRATION_SCRIPT ${RESETTEXT}There are No Logs Older Than $AGELIMIT Days"

  exit 1

fi

 

#Moving and Symlinking Logs

printf '%s\n' "$LOGFILES" | while IFS= read -r line

do

   echo "${REDTEXT}LOG_MIGRATION_SCRIPT ${RESETTEXT}Moving $line to Archive Folder"

   mv $LOGLOCATION/"$line" $ARCHIVELOCATION

   echo "${REDTEXT}LOG_MIGRATION_SCRIPT ${RESETTEXT}Symlinking $line to Back to Log Folder"

   ln -s $ARCHIVELOCATION/"$line" $LOGLOCATION/$line

done
