#!/bin/bash
#Author: Leopard
set -euo pipefail

# Checking if the script is being executed as root or not.
if [[ "$(id -u)" -ne 0 ]]; then
    error "Please run this script using ROOT or SUDO. (For example: 'sudo $0')!"
    exit 1
fi

if ! command -v figlet &> /dev/null; then
  apt-get -qq install -y figlet
fi

# Some important configurations such colors and Helping Functions
YELLOW="\033[1;33m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
success() { echo -e "${GREEN}[ OK ]${NC} $1"; }

clear
echo -e "${GREEN}[###] STARTING THE PENTESTER'S KALI LINUX INSTALL SCRIPT [###]${NC}"
figlet "PENTESTER'S KALI - LINUX" || echo -e "${YELLOW}(Install 'figlet' to see ASCII banners)${NC}"
echo -e "${GREEN}[###] ------------------------------------------------------------------------ [###]${NC}"

export DEBIAN_FRONTEND=noninteractive
echo '* libraries/restart-without-asking boolean true' | debconf-set-selections

TARGET_USER=${SUDO_USER:-$(whoami)}
TARGET_HOME=$(eval echo "~$TARGET_USER")
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Performing Necessary Updates and Upgrades to the Target System
info "[##] Updating and Upgrading the System Packages  --------------------- [ #1 ]"
apt-get update -qq
apt-get upgrade -y -qq
apt-get full-upgrade -y -qq
apt-get autoremove -y -qq

# Installing the necessary requried packages for Binary Exploitation
info "[##] Installing the Compulsory/Required Packages  -------------------- [ #2 ]"
apt-get -qq install -y python3 python3-dev python3-venv python3-pip pipx gdb radare2 pwncat strace ltrace binutils python3-requests > /dev/null
apt-get -qq install -y netcat-traditional ncat nmap python3-flask socat impacket-scripts plocate > /dev/null

# Creating a new Python3 Virtual Environment in the Home Directory.
info "[##] Creating a Python3 Environment & Installing Libraries  ---------- [ #3 ]"
python3 -m venv "$TARGET_HOME/PWN-VENV"
source "$TARGET_HOME/PWN-VENV/bin/activate"
pip3 install pwntools pwn-flashlib ROPGadget one_gadget > /dev/null
deactivate
chown -R "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/PWN-VENV"

# Finall Update, Upgrade and Auto-remove.
info "[##] Final Update and Upgrade to the System Packages  ---------------- [ #5 ]"
apt-get -qq update
apt-get -qq upgrade -y
apt-get -qq full-upgrade -y
apt-get -qq autoremove -y
updatedb
unset DEBIAN_FRONTEND

# Installing some necessary Python3 Cmdlets through the Pipx Command.
info "[##] Creating tools and Cmdlets via PIPX  ---------------------------- [ #4 ]"
sudo -u "$TARGET_USER" HOME="$TARGET_HOME" pipx install pwntools ROPGadget one_gadget impacket --include-deps > /dev/null
sudo -u "$TARGET_USER" HOME="$TARGET_HOME" pipx ensurepath > /dev/null
info "[!!!] '!/.local/bin' has been added to PATH, Please Open a new terminal or Re-login."
info "[!!!] Alternatively, you can source your shell's config file with 'source ~/.bashrc'"

echo -e "${GREEN}[###] ------------------------------------------------------------------------ [###]${NC}"
echo -e "${GREEN}[###] Kali-Linux PWN / Binary Exploitation Environment Setup is finally Complete.!!!${NC}"
echo -e "${GREEN}[###] ------------------------------------------------------------------------ [###]${NC}"
