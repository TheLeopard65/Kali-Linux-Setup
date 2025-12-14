#!/bin/bash
#Author: Leopard

# Checking if the script is being executed as root or not.
if [[ "$(id -u)" -ne 0 ]]; then
    error "Please run this script using ROOT or SUDO. (For example: 'sudo $0')!"
    exit 1
fi

# Some important configurations such colors and Helping Functions
set -eo pipefail
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"
error() { echo -e "${RED}[ERROR]${NC} $1"; }
success() { echo -e "${GREEN}[ OK ]${NC} $1"; }

clear
echo -e "${GREEN}[###] STARTING THE PENTESTER'S KALI LINUX INSTALL SCRIPT [###]${NC}"
figlet "PENTESTER'S KALI - LINUX" || echo -e "${YELLOW}(Install 'figlet' to see ASCII banners)${NC}"
echo -e "${GREEN}[###] ------------------------------------------------------------------------ [###]${NC}"

export DEBIAN_FRONTEND=noninteractive
echo '* libraries/restart-without-asking boolean true' | debconf-set-selections

if ! command -v figlet &> /dev/null; then
  apt-get -qq install -y figlet
fi

TARGET_USER=${SUDO_USER:-$(whoami)}
TARGET_HOME=$(eval echo "~$TARGET_USER")
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Performing Necessary Updates and Upgrades to the Target System
apt-get update -qq
apt-get upgrade -y -qq
apt-get full-upgrade -y -qq
apt-get autoremove -y -qq

# Installing the necessary requried packages for Binary Exploitation
apt-get -qq install -y python3 python3-dev python3-venv python3-pip pipx gdb radare2 pwncat strace ltrace binutils python3-requests > /dev/null
apt-get -qq install -y netcat-traditional ncat nmap python3-flask socat impacket-scripts plocate > /dev/null

# Creating a new Python3 Virtual Environment in the Home Directory.
python3 -m venv "$TARGET_HOME/PWN-VENV"
source "$TARGET_HOME/PWN-VENV/bin/activate"
pip3 install pwntools pwn-flashlib ROPGadget one_gadget
deactivate
chown -R "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/PWN-VENV"

# Installing some necessary Python3 Cmdlets through the Pipx Command.
pipx install pwntools ROPGadget one_gadget pwn-flashlib impacket --include-deps
pipx --ensure-path

# Finall Update, Upgrade and Auto-remove.
apt-get -qq update
apt-get -qq upgrade -y
apt-get -qq full-upgrade -y
apt-get -qq autoremove -y
updatedb
unset DEBIAN_FRONTEND

echo -e "${GREEN}[###] ------------------------------------------------------------------------ [###]${NC}"
echo -e "${GREEN}[###] Kali-Linux PWN / Binary Exploitation Environment Setup is finally Complete.!!!${NC}"
echo -e "${GREEN}[###] ------------------------------------------------------------------------ [###]${NC}"
