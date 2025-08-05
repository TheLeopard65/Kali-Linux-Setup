#!/bin/bash

# Checking if user is root
if [ $(whoami) != "root" ]; then
    echo "SYNTAX: PLEASE RUN THIS SCRIPT WITH ROOT/SUDO PRIVILEGES !!"
    exit 1
fi

clear
echo "[###] STARTING THE PENTESTER'S KALI - LINUX UPDATE SETUP [###]"
figlet "PENTESTER'S KALI - LINUX"
echo "[###] -------------------------------------------------- [###]"
# Updating and Upgrading the system & Databases
apt-get -qq update
apt-get -qq upgrade -y
apt-get -qq full-upgrade -y
apt-get -qq autoremove -y
searchsploit -u
nmap --script-updatedb
updatedb
cd
