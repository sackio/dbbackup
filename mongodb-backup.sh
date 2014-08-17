#!/bin/bash

############################################
# Basic script to backup mongodb
############################################

MONGO_BAK_PATH="$MONGO_BAK_PATH"
LABEL="$LABEL"

echo "Backing up mongodb databases and compressing" 

ARCHIVE="$MONGO_BAK_PATH/$LABEL-$(date +%Y-%m-%d=%H:%M)"

mongodump -o "$ARCHIVE";
tar cvzf "$ARCHIVE.tar.gz" "$ARCHIVE";
rm -rf "$ARCHIVE"

echo "...done"
