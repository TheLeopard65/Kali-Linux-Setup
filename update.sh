#!/bin/bash
#Author: TheLeopard65

set -euo pipefail

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

if [ $(whoami) != "root" ]; then
    echo "SYNTAX: PLEASE RUN THIS SCRIPT WITH ROOT/SUDO PRIVILEGES !!"
    exit 1
fi

if ! command -v figlet &> /dev/null; then
    apt-get update || true
    apt-get -qq install -y figlet || true
fi

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
figlet "PENTESTER'S KALI - LINUX" || echo -e "${YELLOW}(Install 'figlet' to see ASCII banners)${NC}"
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"

apt-get -qq update
apt-get -qq upgrade -y
apt-get -qq full-upgrade -y
apt-get -qq autoremove -y
searchsploit -u
nmap --script-updatedb
updatedb
cd

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
echo -e "${GREEN}[###] Kali-Linux Pentester's Environment Update is finally complete!${NC}"
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
