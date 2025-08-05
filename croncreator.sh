#!/bin/bash

clear
echo "[###] STARTING THE PENTESTER'S KALI - LINUX UPDATE SETUP [###]"
figlet "PENTESTER'S KALI - LINUX"
echo "[###] -------------------------------------------------- [###]"

# Check if the User is Root
echo "[1/7] CHECKING IF YOU HAVE ROOT PRIVILEGES!!"
if [ "$(whoami)" != "root" ]; then
    echo "SYNTAX: Please run this script as ROOT or using SUDO"
    exit 1
fi

# Define paths
echo "[2/7] DEFINING REQUIRED FILE PATH VARIABLES !!"
SCRIPT_SRC="./update.sh"
SCRIPT_DEST="/root/.update.sh"
LOG_FILE="/var/log/update.log"

# Copy the script
echo "[3/7] COPYING SCRIPT TO ROOT DIRECTORY!!"
cp "$SCRIPT_SRC" "$SCRIPT_DEST"
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to copy $SCRIPT_SRC to $SCRIPT_DEST"
    exit 1
fi

# Set permissions
echo "[4/7] CHANGING THE FILE PERMISSIONS !!"
chmod 700 "$SCRIPT_DEST"

# Define the cron job
echo "[5/7] DEFINING THE CRONJOB !!"
JOB="0 0 1 * * $SCRIPT_DEST >> $LOG_FILE 2>&1"

# Check if the script file exists
echo "[6/7] PERFORMING FINAL CHECK ON FILE !!"
if [ ! -f "$SCRIPT_DEST" ]; then
    echo "ERROR: File not found: $SCRIPT_DEST"
    exit 1
fi

# Create the cron job via a secure method
echo "[7/7] CREATING THE CRONJOB !!"
TMP=$(mktemp)
crontab -l 2>/dev/null | grep -v "$SCRIPT_DEST" > "$TMP"
echo "$JOB" >> "$TMP"
crontab "$TMP"
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install new crontab"
    rm "$TMP"
    exit 1
fi
rm "$TMP"

# Final Echo
echo "[###] SUCCESS: CRON-JOB ADDED SUCCSSFULLY!"
