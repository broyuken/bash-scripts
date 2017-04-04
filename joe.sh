#!/bin/bash
#
# Scan mag stripe card and return the type
#
# Author:  Brian Roy
# Update:  4-3-2017

read -p "Please Scan Card Now   " CARD_DATA

STARBUCKS_REGEX="^%B[0-9]{16}[\^][0-9]{4}/"

if [[ $CARD_DATA =~ $STARBUCKS_REGEX ]]; then
        echo "This is a Starbucks Card"
else
        echo "This is NOT a Starbucks Card"
fi
