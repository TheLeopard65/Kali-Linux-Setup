#!/bin/bash
#Author: Leopard

set -euo pipefail

YELLOW="\033[1;33m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
success() { echo -e "${GREEN}[ OK ]${NC} $1"; }

if [[ "$(id -u)" -ne 0 ]]; then
    error "Please run this script using ROOT or SUDO. (For example: 'sudo $0')!"
    exit 1
fi

if ! command -v figlet &> /dev/null; then
  apt-get update || true
  apt-get install -y figlet &> /dev/null
fi

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
figlet "PENTESTER'S KALI - LINUX" || echo -e "${YELLOW}(Install 'figlet' to see ASCII banners)${NC}"
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"

export DEBIAN_FRONTEND=noninteractive
echo '* libraries/restart-without-asking boolean true' | debconf-set-selections

TARGET_USER=${SUDO_USER:-$(whoami)}
TARGET_HOME=$(eval echo "~$TARGET_USER")
SCRIPT_DIR=$(dirname "$(realpath "$0")")

info "[##] Updating and Upgrading the System Packages  ------------------------------------------------------------------- [ #1 ]"
apt-get update
apt-get upgrade -y
apt-get full-upgrade -y
apt-get autoremove -y

info "[##] Installing the Compulsory/Required Packages  ------------------------------------------------------------------ [ #2 ]"
apt-get install -y python3 python3-dev python3-venv python3-pip pipx gdb radare2 pwncat strace ltrace binutils python3-requests netcat-traditional \
ncat nmap python3-flask socat impacket-scripts plocate python3-setuptools ruby ruby-dev rubygems

info "[##] Creating a Python3 Environment & Installing Libraries  -------------------------------------------------------- [ #3 ]"
python3 -m venv "$TARGET_HOME/PWN-VENV"
source "$TARGET_HOME/PWN-VENV/bin/activate"
pip3 install pwntools pwn-flashlib ROPGadget
gem install one_gadget
deactivate
chown -R "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/PWN-VENV"

info "[##] Final Update and Upgrade to the System Packages  -------------------------------------------------------------- [ #4 ]"
apt-get update
apt-get upgrade -y
apt-get full-upgrade -y
apt-get autoremove -y
updatedb
unset DEBIAN_FRONTEND

info "[##] Creating tools and Cmdlets via PIPX  -------------------------------------------------------------------------- [ #5 ]"

for pkg in pwntools ROPGadget impacket; do
    sudo -u "$TARGET_USER" HOME="$TARGET_HOME" pipx install "$pkg" --include-deps
done
sudo -u "$TARGET_USER" HOME="$TARGET_HOME" pipx ensurepath

info "[!!!] '~/.local/bin' has been added to PATH, Please Open a new terminal or Re-login."
info "[!!!] Alternatively, you can source your shell's config file with 'source ~/.bashrc'"

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
echo -e "${GREEN}[###] Kali-Linux Pentester's PWN Lab Setup is finally complete!${NC}"
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
