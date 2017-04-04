#!/bin/bash
# Check Point Service Level License Change
# Author: Brian Roy
# Check Point Software Technologies
# Update 3/2/2017

# Check if SERVICELEVEL is a valid selection
if [[ "$1" =~ ^"(Essential|Core|Complete)"$ ]]; then
        SERVICELEVEL=$1
        echo -n "Gateway will be set to to "; tput setaf 2; echo "$SERVICELEVEL"; tput sgr0
else
        tput setaf 1; echo "ERROR"; tput sgr0
        echo "Please enter one of the following (Case Sensitive)"
        tput setaf 3
        echo "Essential"
        echo "Core"
        echo "Complete"
        tput setaf 6; echo "Usage: ./ServiceLevel.sh ServiceLevel"; tput sgr0
  exit 2
fi

#Define $CPLICPUT
if [[ "$SERVICELEVEL" = "Essential" ]]; then
CPLICPUT="cplic put XXXXXXXXXX"

elif [[ "$SERVICELEVEL" = "Core" ]]; then
CPLICPUT="YYYYYYYYYY"

elif [[ "$SERVICELEVEL" = "Complete" ]]; then
CPLICPUT="ZZZZZZZZZZ"
fi

# Remove Old License
if rm $CPDIR/conf/cp.license 2>/dev/null; then
        echo "Old license removed successfully"
else
        tput setaf 1; echo "ERROR"; tput sgr0
        echo "Old license could not be removed"
  exit 4
fi

# Add New License
if $CPLICPUT 2>/dev/null; then
        echo "License added successfully"
else
        tput setaf 1; echo "ERROR"; tput sgr0
        echo "License not added"
  exit 4
fi

#Verify License
if cplic print; then
        echo "License Info Below:"
else
        tput setaf 1; echo "ERROR"; tput sgr0
        echo "No license found"
  exit 6
fi

# Reset terminal colors back to defaults
tput sgr0
