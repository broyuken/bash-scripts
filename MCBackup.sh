#!/bin/bash
#
# Minecraft Server Backup
#
# Author: Brian Roy
#
# Update 9/28/2017
#
#Variables
SERVERLOCATION=/home/mcadmin/MinecraftServer
BACKUPLOCATION=/MinecraftBackup
AGELIMIT=30
DATE=$(date +'%m_%d_%Y')
OLDBACKUPS=$(find $BACKUPLOCATION -maxdepth 1 -name *.tgz -mtime +$AGELIMIT -type f -exec echo "{}" \; | awk -F "/" '{print $(NF)}' )
NUMBEROFOLDBACKUPS=$(find $BACKUPLOCATION -maxdepth 1 -name \*.tgz -mtime +$AGELIMIT -type f -exec echo "{}" \; | wc -l )
REDTEXT=`tput setaf 1`
RESETTEXT=`tput sgr0`

# TGZ the Minecraft Server Directory
if tar -czf $BACKUPLOCATION/DragonServerBackup_$DATE.tgz $SERVERLOCATION 2>/dev/null; then
        echo "${REDTEXT}MINECRAFT_SERVER_BACKUP${RESETTEXT} Backup Successfully created at $BACKUPLOCATION/DragonServerBackup_$DATE.tgz"
else
        echo "${REDTEXT}MINECRAFT_SERVER_BACKUP ERROR${RESETTEXT}";
        echo "Backup Failed"
  exit 1
fi

#Find backups older than $AGELIMIT and print them
echo "${REDTEXT}MINECRAFT_SERVER_BACKUP${RESETTEXT}The Below Backup Archives are Older Than $AGELIMIT Days and will be deleted"
if [ $NUMBEROFOLDBACKUPS -gt 0 ]; then
  echo "$OLDBACKUPS"
else
  echo "${REDTEXT}MINECRAFT_SERVER_BACKUP ${RESETTEXT}There are No Archives Older Than $AGELIMIT Days"
  exit 2
fi

#Removing Old Backups
printf '%s\n' "$OLDBACKUPS" | while IFS= read -r line
do
if rm $BACKUPLOCATION/"$line" 2>/dev/null; then
        echo "${REDTEXT}MINECRAFT_SERVER_BACKUP ${RESETTEXT}Removing $line"
else
        echo "${REDTEXT}MINECRAFT_SERVER_BACKUP ERROR${RESETTEXT}";
        echo "Removing Old Backup Failed"
  exit 3
fi
done
