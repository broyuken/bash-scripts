#!/bin/bash
#
# Script to create sftp users in a jail
#
# Author:  Brian Roy
# Update:  4-7-2018

#Set HOMEPATH
HOMEPATH=/home

#Set DOMAINCONTROLLER
DOMAINCONTROLLER=dc1.example.com

#Set USERGROUP
USERGROUP=domain^users

#Set JAILDIR
JAILDIR=

#Get Users Username
read -p "Username to create: " USER

#create user directory
if sudo mkdir $HOMEPATH/$USER 2>/dev/null; then
  echo "User directory created successfully"
else
  tput setaf 1; echo "ERROR"; tput sgr0
  echo "User directory already exists"
  while true; do
      read -sn1 -p "Do you wish to continue (Y/N)" yn
    case $yn in
        [Yy]* ) echo -e "\nYou selected yes, continuing"; break;;
        [nn]* ) echo -e "\nYou selected no, exiting"; exit 1;;
        * ) echo "Please answer Y or N.";;
    esac
  done
fi

#set owner to root
if sudo chown root:$USERGROUP $HOMEPATH/$USER 2>/dev/null; then
  echo "User directory ownership changed to root"
else
  tput setaf 1; echo "ERROR"; tput sgr0
  echo "Cannot change user directory ownership. Check that $USERGROUP exists on $DOMAINCONTROLLER"
  exit 1
fi

#create upload and download directories
for DIRECTORY in upload download
do
  if [ ! -d "$HOMEPATH/$USER/$DIRECTORY" ]; then
    sudo mkdir $HOMEPATH/$USER/$DIRECTORY
  else
    tput setaf 1; echo "ERROR"; tput sgr0
    echo "$DIRECTORY directory already exists"
    while true; do
        read -sn1 -p "Do you wish to continue (Y/N)" yn
      case $yn in
        [Yy]* ) echo -e "\nYou selected yes, continuing"; break;;
        [nn]* ) echo -e "\nYou selected no, exiting"; exit 1;;
        * ) echo "Please answer Y or N.";;
      esac
    done
  fi
done

#set owner of upload directory to $USER
if sudo chown $USER:$USERGROUP $HOMEPATH/$USER/upload 2>/dev/null; then
  echo "Upload directory ownership changed to $USER"
else
  tput setaf 1; echo "ERROR"; tput sgr0
  echo "Cannot set ownership of upload directory"
  echo "Please check that the user has been created on $DOMAINCONTROLLER"
  exit 1
fi

#mount JAILDIR inside jail
if [ -z "$JAILDIR" ]; then
  echo "No jaildir defined, download dir will be empty"
else
  if [ -d "$JAILDIR" ]; then
    echo "$JAILDIR is a valid directory. Mounting inside jail";
    sudo mount --bind $JAILDIR $HOMEPATH/$USER/download 2>/dev/null
  else
    tput setaf 1; echo "ERROR"; tput sgr0
    echo "$JAILDIR does not exist, please try again with a valid directory"
    exit 1
  fi

fi
echo "User $USER successfully created"
