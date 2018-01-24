#!/bin/bash
#
# Script to create sftp users in a jail
#
# Author:  Brian Roy
# Update:  1-27-2017

#Error Checking
#set -o pipefail -e

#Set HOMEPATH
HOMEPATH=/home

#Set DOMAINCONTROLLER
DOMAINCONTROLLER=dc1

#Get Users Username
read -p "Username to create: " USER

#create user directory
if sudo mkdir $HOMEPATH/$USER 2>/dev/null; then
  echo "User directory created successfully"
else
  echo "ERROR: User directory already exists"
  exit 1
fi

#set owner to root
if sudo chown root:domain^users $HOMEPATH/$USER 2>/dev/null; then
  echo "User directory ownership changed to root"
else
  echo "ERROR: Cannot change user directory ownership"
  exit 1
fi

#create upload and download directories
if sudo mkdir $HOMEPATH/$USER/upload 2>/dev/null; sudo mkdir $HOMEPATH/$USER/download 2>/dev/null; then
  echo "Created upload and download directories"
else
  echo "ERROR: Cannot create upload or download directories"
  exit 1
fi

#set owner of upload directory to $USER
if sudo chown $USER:domain^users $HOMEPATH/$USER/upload 2>/dev/null; then
  echo "Upload directory ownership changed to $USER"
else
  echo "ERROR: Cannot set ownership of upload directory"
  echo "Please check that the user has been created on $DOMAINCONTROLLER"
  exit 1
fi

echo "User $USER successfully created"
