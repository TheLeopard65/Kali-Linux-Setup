#!/bin/bash
#Author: TheLeopard65

# ------------------------------------- COLORS --------------------------------

set -eo pipefail
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# ------------------------------------- INFO LEVELS ---------------------------

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
success() { echo -e "${GREEN}[ OK ]${NC} $1"; }

# ------------------------------------- HEADER/TITLE --------------------------

if ! command -v figlet &> /dev/null; then
  apt-get -qq install -y figlet
fi

clear
echo -e "${GREEN}[###] STARTING THE PENTESTER'S KALI LINUX INSTALL SCRIPT [###]${NC}"
figlet "PENTESTER'S KALI - LINUX" || echo -e "${YELLOW}(Install 'figlet' to see ASCII banners)${NC}"
echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"

export DEBIAN_FRONTEND=noninteractive
echo '* libraries/restart-without-asking boolean true' | debconf-set-selections

# ------------------------------------- PRIVILEGE CHECK -----------------------

if [[ "$(id -u)" -ne 0 ]]; then
    error "Please run this script using ROOT or SUDO. (For example: 'sudo $0')!"
    exit 1
fi

USER_HOME=${SUDO_USER:-$(logname)}

# ------------------------------------- USER PROMPTS --------------------------

prompt_yes_no() {
    read -p "[#] $1 (Y/N) [default: N]: " reply
    reply=${reply:-N}
    echo "${reply,,}"
}

pipt=$(prompt_yes_no "1. Install pip3 & pipx tools? -------")
pyp2=$(prompt_yes_no "2. Install Python2 & pip2 tools? ----")
penv=$(prompt_yes_no "3. Install Older Python3 Versions? --")
snpd=$(prompt_yes_no "4. Install Snapd & Snap packages? ---")
narc=$(prompt_yes_no "5. Modify nanorc for easier usage? --")
zshc=$(prompt_yes_no "6. Modify .zshrc for better UX? -----")
barc=$(prompt_yes_no "7. Modify .bashrc for better UX? ----")
gitx=$(prompt_yes_no "8. Add global Git configurations? ---")
panl=$(prompt_yes_no "9. Modify Taskbar/Panel Shortcuts? --")
echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"

# ------------------------------------- SYSTEM UPDATES ------------------------

info "[###] Updating & upgrading system..."
apt-get -qq update && apt-get -qq upgrade -y

# ------------------------------------- TOOLS INSTALLATION --------------------

info "[##] Installing Compulsory/Required Tools --------------- [ TOOLS = 37 ]"
apt-get -qq install -y wget curl whois openvpn wordlists seclists webshells exploitdb dpkg netcat-traditional ncat plocate git eog tor libffi-dev snapd git-all
apt-get -qq install -y metasploit-framework powershell git-lfs build-essential firefox-esr docker.io docker-compose libssl-dev net-tools torbrowser-launcher
apt-get -qq install -y coreutils uuid ntpsec-ntpdate axel xclip openssl flameshot dkms linux-headers-$(uname -r)

info "[##] Installing Service-Specific Tools ------------------ [ TOOLS = 27 ]"
apt-get -qq install -y smbclient enum4linux enum4linux-ng freerdp3-x11 rdesktop remmina evil-winrm sqlite3 default-mysql-server sqsh odat smbmap smtp-user-enum
apt-get -qq install -y sqlmap onesixtyone nbtscan snmp snmpcheck samba samba-common-bin rpcbind kubectl mdbtools xtightvncviewer redis mongodb-clients ansible

info "[##] Installing Web Application Scanners ---------------- [ TOOLS = 21 ]"
apt-get -qq install -y gobuster ffuf wafw00f dirbuster dirsearch sublist3r feroxbuster wpscan openvas-scanner sslyze nikto wfuzz davtest cadaver dirb evilginx2
apt-get -qq install -y xsser burpsuite beef zaproxy shellfire

info "[##] Installing Miscellaneous Tools --------------------- [ TOOLS = 21 ]"
apt-get -qq install -y faketime binwalk steghide libimage-exiftool-perl zbar-tools pdf-parser foremost ffmpeg iptables cme pftools shellter gophish clamav jq xxd
apt-get -qq install -y autopsy powershell-empire ghostwriter pandoc dradis rlwrap liblnk-utils

info "[##] Installing Language & Support Tools ---------------- [ TOOLS = 16 ]"
apt-get -qq install -y python3 python3-dev python3-pip pipx npm nodejs postgresql libwine openjdk-11-jdk golang golang-go scapy bash-completion php ruby perl

info "[##] Installing Port & Network Scanners ----------------- [ TOOLS = 13 ]"
apt-get -qq install -y nmap masscan unicornscan amass dnsenum dnsrecon netdiscover hping3 rizin sslh httprobe fping eyewitness

info "[##] Installing Binary Exploitation Tools --------------- [ TOOLS = 10 ]"
apt-get -qq install -y checksec ghidra pwncat radare2 gdb ltrace strace ollydbg binutils libc-bin

info "[##] Installing Active Directory Tools ------------------- [ TOOLS = 9 ]"
apt-get -qq install -y bloodhound bloodhound.py certipy-ad responder ldap-utils lapsdumper gpp-decrypt bloodyad bloodhound-ce-python

info "[##] Installing Password Cracking Tools ------------------ [ TOOLS = 7 ]"
apt-get -qq install -y hashid john hashcat hydra medusa cewl cupp passwordsafe

info "[##] Installing Windows-Specific Tools ------------------- [ TOOLS = 7 ]"
apt-get -qq install -y windows-binaries mimikatz rubeus nishang powersploit laudanum peass

info "[##] Installing Pivoting & Tunneling Tools --------------- [ TOOLS = 6 ]"
apt-get -qq install -y chisel ligolo-ng socat dnscat2 ptunnel sshuttle proxychains

info "[##] Installing Exploitation Tools ----------------------- [ TOOLS = 5 ]"
apt-get -qq install -y netexec crackmapexec impacket-scripts pompem sliver

info "[##] Installing Creds & Cloud Scan Tools ----------------- [ TOOLS = 3 ]"
apt-get -qq install -y trufflehog trivy pacu

info "[##] Installing Network Traffic Tools -------------------- [ TOOLS = 4 ]"
apt-get -qq install -y wireshark tshark sniffglue tcpdump

info "[##] Installing Mobile APK Analysis Tools ---------------- [ TOOLS = 4 ]"
apt-get -qq install -y jadx apktool adb poppler-utils

info "[##] Installing Reconnaissance Tools --------------------- [ TOOLS = 4 ]"
apt-get -qq install -y recon-ng sherlock theharvester linkedin2username

info "[##] Installing Wireless Pentest Tools ------------------- [ TOOLS = 4 ]"
apt-get -qq install -y aircrack-ng reaver wifite kismet-core

# ------------------------------------- PYTHON3 LIBRARIES ---------------------

echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"
info "[##] Installing Web, App & API Python3 Libraries -------- [ TOOLS = 12 ]"
apt-get -qq install -y python3-flask python3-flask-socketio python3-flask-restful python3-bs4 python3-lxml python3-yaml python3-requests python3-selenium
apt-get -qq install -y python3-pyqt5 python3-tk python3-pynput python3-pyautogui

info "[##] Installing Networking Python3 Libraries ------------ [ TOOLS = 12 ]"
apt-get -qq install -y python3-paramiko python3-socketio python3-nmap python3-scapy python3-shodan python3-impacket python3-bcrypt python3-cryptography
apt-get -qq install -y python3-pycryptodome python3-ldap python3-corepywrap python3-requests

info "[##] Installing Miscellaneous Python3 Libraries ---------- [ TOOLS = 8 ]"
apt-get -qq install -y python3-pwntools python3-ropgadget python3-geopy python3-colormap python3-termcolor python3-pil python3-capstone python3-pyftpdlib

info "[##] Installing AI/ML Python3 Libraries ------------------ [ TOOLS = 7 ]"
apt-get -qq install -y python3-numpy python3-pandas python3-matplotlib python3-opencv python3-soundfile python3-pydantic python3-sqlalchemy

# ------------------------------------- PIPX TOOLS ----------------------------

if [[ "$pipt" == "y" ]]; then
	info "[##] Installing Important PIPX Tools -------------------- [ TOOLS = 23 ]"
	pipx install --quiet websocket-client pwnedpasswords geocoder ipython impacket tqdm pytesseract pytest pyinstaller ropgadget pwntools flask pypykatz > /dev/null
	pipx install --quiet defaultcreds-cheat-sheet kerbrute pywhisker droopescan uploadserver wsgidav cheroot xsstrike wesng bloodhound > /dev/null
	pipx ensurepath > /dev/null
fi

# ------------------------------------- OLD PYTHON ----------------------------

if [[ "$pyp2" == "y" ]]; then
	info "[##] Installing Python2 & its Libraries ------------------ [ TOOLS = 3 ]"
	apt-get -qq install -y python2 python2-dev python2-minimal
	curl -s https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip2.py && python2 get-pip2.py > /dev/null
fi

if [[ "$penv" == "y" ]]; then
	info "[##] Installing Older versions of Python3 ---------------- [ TOOLS = 1 ]"
	apt-get -qq install -y pyenv
	pyenv install 3.11.11 3.10.16 3.8.20
fi

# ------------------------------------- ENABLE SNAPD --------------------------

if [[ "$snpd" == "y" ]]; then
	info "[##] Installing Snapd & its packages --------------------- [ TOOLS = 4 ]"
	systemctl enable snapd > /dev/null
	systemctl start snapd > /dev/null
	snap install ngrok > /dev/null
	snap install --classic code > /dev/null
	snap install --edge bashfuscator > /dev/null
fi

# ------------------------------------- DOCKER & WINE32 CONFIG ----------------

usermod -aG docker "$USER_HOME"
dpkg --add-architecture i386 && apt-get -qq update && apt-get -qq install -y wine32

# ------------------------------------- GLOBAL GIT CONFIG ---------------------

if [[ "$gitx" == "y" ]]; then
	info "[##] Configuring GIT Configurations ------------------------- [ MANUAL ]"
	read -p ">>>[#] Please Enter your GitHub/GitLab Username: " git_username
	read -p ">>>[#] Please Enter your GitHub/GitLab Email: " git_email
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global color.ui auto
fi

# ------------------------------------- NANORC MODIFICATIONS ------------------

if [[ "$narc" == "y" ]]; then
    info "[##] Performing NANO Configurations ------------------------- [ MANUAL ]"
    if [[ -f ./resources/nanorc ]]; then
        cp ./resources/nanorc /etc/nanorc
    else
        warn "[!!!] nanorc file not found, skipping copy."
    fi
    if [[ -x ./resources/nano-syntax.sh ]]; then
        bash ./resources/nano-syntax.sh > /dev/null
    else
        warn "[!!!] nano-syntax.sh script missing or not executable, skipping."
    fi
fi

# ------------------------------------- BASHRC CUSTOMIZATION ------------------

if [[ "$barc" == "y" ]]; then
    info "[##] Performing BASH Configurations ------------------------- [ MANUAL ]"
    if [[ -f ./resources/bashrc ]]; then
        cp ./resources/bashrc "/home/${USER_HOME}/.bashrc"
        cp ./resources/bashrc /root/.bashrc
        warn "[#] Manual action needed: Please run 'source ~/.bashrc' after this script."
    else
        warn "[!!!] bashrc file not found in current directory, skipping copy."
    fi
fi

# ------------------------------------- ZSHRC CUSTOMIZATION -------------------

if [[ "$zshc" == "y" ]]; then
    info "[##] Performing ZSH Configurations -------------------------- [ MANUAL ]"
    if [[ -f ./resources/zshrc ]]; then
        cp ./resources/zshrc "/home/${USER_HOME}/.zshrc"
        cp ./resources/zshrc /root/.zshrc
        warn "[#] Manual action needed: Please run 'source ~/.zshrc' after this script."
    else
        warn "[!!!] zshrc file not found in current directory, skipping copy."
    fi
fi

# ------------------------------------- PANEL CUSTOMIZATION -------------------

if [[ "$panl" == "y" ]]; then
    info "[##] Performing Panel Configurations ------------------------ [ MANUAL ]"
    if [[ -f ./resources/xfce4-panel.xml ]]; then
        cp ./resources/xfce4-panel.xml "/home/${USER_HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
        cp ./resources/xfce4-panel.xml /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
        cp ./resources/xfce4-panel.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
    else
        warn "[!!!] Xfce4-panel.xml file not found in current directory, skipping copy."
    fi
fi

# ------------------------------------- POST SETUP COMMANDS -------------------

info "[###] Finalizing the PENTESTER'S KALI - LINUX Setup --------- [ MANUAL ]"

if [[ -f /usr/share/wordlists/rockyou.txt.gz ]]; then
    gzip -d /usr/share/wordlists/rockyou.txt.gz 2>/dev/null
fi

searchsploit -u > /dev/null
nmap --script-updatedb > /dev/null
greenbone-nvt-sync --quiet
freshclam --quiet
apt-get -qq update
apt-get -qq upgrade -y
apt-get -qq full-upgrade -y
apt-get -qq autoremove -y
updatedb
unset DEBIAN_FRONTEND

# ------------------------------------- DIR SETUP & SSH KEY -------------------

info "[###] Setting up the User's Home Directory ------------------ [ MANUAL ]"

cd "/home/$USER_HOME/" && mkdir -p {recon,loot,exploits,transfer,creds,tools,misc,CTF/{rev,pwn,web,misc,crypto,forensics},OpenVPN}
sudo chown -R $USER_HOME:$USER_HOME /home/$USER_HOME/{recon,loot,exploits,transfer,tools,misc,creds,CTF,OpenVPN}

SSH_KEY="/home/$USER_HOME/creds/ssh-key"

if [[ ! -f "$SSH_KEY" ]]; then
	cd /home/$USER_HOME/creds/
    ssh-keygen -t ed25519 -f "$SSH_KEY" -N "" -q
    chmod 600 "$SSH_KEY"
	chmod 644 "$SSH_KEY.pub"
	cd ..
fi

# ------------------------------------- COMPLETION ----------------------------

echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"
echo -e "${GREEN}[###] Kali-Linux Pentest environment setup is finally complete!${NC}"
if [[ "$barc" == "y" ]]; then
	echo -e "${YELLOW}[###] Restart your terminal or run 'source ~/.bashrc' to apply all changes.${NC}"
fi
if groups "$USER_HOME" | grep -q '\bdocker\b'; then
    echo -e "${YELLOW}[###] You may need to LOG OUT and back in to apply DOCKER group membership.${NC}"
fi
echo -e "${RED}[###] Please Restart/Reboot your System for some of the changes to take Effect.!!!${NC}"
echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"
