#!/bin/bash
# Author: TheLeopard65

# ------------------------------------- COLORS --------------------------------

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

clear
echo -e "${GREEN}[###] STARTING THE PENTESTER'S KALI LINUX INSTALL SCRIPT [###]${NC}"
figlet "PENTESTER'S KALI - LINUX" || echo -e "${YELLOW}(Install 'figlet' to see ASCII banners)${NC}"
echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"

# ------------------------------------- PRIVILEGE CHECK -----------------------

if [[ "$(whoami)" != "root" ]] || [[ -z "$SUDO_USER" ]]; then
    error "Please run this script using sudo, not directly as root (e.g., 'sudo ./install.sh')!"
    exit 1
fi

# ------------------------------------- USER PROMPTS --------------------------

prompt_yes_no() {
    read -p "[#] $1 (Y/N) [default: N]: " reply
    reply=${reply:-N}
    echo "${reply,,}"
}

pipt=$(prompt_yes_no "Install pip3 & pipx tools?")
pyp2=$(prompt_yes_no "Install Python2 & pip2 tools?")
gitx=$(prompt_yes_no "Add global Git configurations?")
bashrc_change=$(prompt_yes_no "Modify .bashrc for better UX?")
nanorc_change=$(prompt_yes_no "Modify nanorc for enhanced usage?")
echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"

# ------------------------------------- SYSTEM UPDATES ------------------------

info "[###] Updating & upgrading system..."
apt-get -qq update && apt-get -qq upgrade -y

# ------------------------------------- TOOLS INSTALLATION --------------------

info "[##] Installing Compulsory/Required Tools --------------- [ TOTAL = 34 ]"
apt-get -qq install -y wget curl whois openvpn wordlists seclists webshells exploitdb nmap dpkg python3 python3-dev netcat-traditional ncat plocate git eog tor \
metasploit-framework powershell git-all git-lfs build-essential firefox-esr python3-pip pipx docker.io docker-compose libssl-dev net-tools libffi-dev snapd \
torbrowser-launcher

info "[##] Installing Language & Support Tools ---------------- [ TOTAL = 12 ]"
apt-get -qq install -y npm nodejs postgresql libwine openjdk-11-jdk golang golang-go python3-requests python3-pwntools scapy bash-completion python3-pycryptodome

info "[##] Installing Service-Specific Tools ------------------ [ TOTAL = 18 ]"
apt-get -qq install -y smbclient enum4linux enum4linux-ng freerdp3-x11 evil-winrm sqlite3 default-mysql-server sqsh odat smbmap smtp-user-enum sqlmap onesixtyone \
nbtscan snmp snmpcheck samba-common-bin rpcbind

info "[##] Installing Miscellaneous Tools --------------------- [ TOTAL = 16 ]"
apt-get -qq install -y faketime binwalk steghide libimage-exiftool-perl zbar-tools pdf-parser foremost ffmpeg iptables cme pftools shellter gophish clamav \
autopsy powershell-empire

info "[##] Installing Web Application Scanners ---------------- [ TOTAL = 19 ]"
apt-get -qq install -y gobuster ffuf wafw00f dirbuster dirsearch sublist3r feroxbuster wpscan openvas-scanner sslyze nikto wfuzz davtest cadaver dirb evilginx2 \
xsser burpsuite beef

info "[##] Installing Port & Network Scanners ----------------- [ TOTAL = 12 ]"
apt-get -qq install -y nmap masscan unicornscan amass dnsenum dnsrecon netdiscover hping3 rizin sslh httprobe fping

info "[##] Installing Host-Specific Tools ---------------------- [ TOTAL = 6 ]"
apt-get -qq install -y windows-binaries mimikatz rubeus nishang powersploit laudanum

info "[##] Installing Active Directory Tools ------------------- [ TOTAL = 7 ]"
apt-get -qq install -y bloodhound bloodhound.py certipy-ad responder ldap-utils lapsdumper gpp-decrypt

info "[##] Installing Exploitation Tools ----------------------- [ TOTAL = 4 ]"
apt-get -qq install -y netexec crackmapexec impacket-scripts pompem

info "[##] Installing Creds & Cloud Scan Tools ----------------- [ TOTAL = 3 ]"
apt-get -qq install -y trufflehog trivy pacu

info "[##] Installing Network Traffic Tools -------------------- [ TOTAL = 4 ]"
apt-get -qq install -y wireshark tshark sniffglue tcpdump

info "[##] Installing Password Cracking Tools ------------------ [ TOOLS = 5 ]"
apt-get -qq install -y hashid john hashcat hydra medusa cewl

info "[##] Installing Binary Exploitation Tools ---------------- [ TOOLS = 8 ]"
apt-get -qq install -y checksec ghidra pwncat radare2 gdb ltrace strace ollydbg

info "[##] Installing Pivoting & Tunneling Tools --------------- [ TOOLS = 6 ]"
apt-get -qq install -y chisel ligolo-ng socat dnscat2 ptunnel sshuttle proxychains

info "[##] Installing Mobile APK Analysis Tools ---------------- [ TOOLS = 3 ]"
apt-get -qq install -y jadx apktool adb

info "[##] Installing Reconnaissance Tools --------------------- [ TOOLS = 4 ]"
apt-get -qq install -y recon-ng sherlock theharvester linkedin2username

info "[##] Installing Wireless Pentest Tools ------------------- [ TOOLS = 4 ]"
apt-get -qq install -y aircrack-ng reaver wifite kismet-core

# ------------------------------------- PYTHON3 LIBRARIES ---------------------

echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"
info "[##] Installing Important Python3 Libraries ------------- [ TOOLS = 37 ]"
apt-get -qq install -y python3-flask python3-flask-socketio python3-bcrypt python3-flask-restful python3-bs4 python3-numpy python3-pandas python3-pyqt5 python3-tk \
python3-matplotlib python3-paramiko python3-socketio python3-nmap python3-lxml python3-selenium python3-yaml python3-geopy python3-colormap python3-termcolor \
python3-pydantic python3-cryptography python3-sqlalchemy python3-opencv python3-pil python3-pyautogui python3-soundfile python3-pynput python3-capstone \
python3-corepywrap python3-impacket python3-ropgadget python3-scapy python3-shodan python3-pyqt5 python3-ldap

# ------------------------------------- PIPX TOOLS ----------------------------

if [[ "$pipt" == "y" ]]; then
	info "[##] Installing Important PIPX Tools ---------------- [ TOOLS = 15 ]"
    pipx install --quiet websocket-client pwnedpasswords geocoder ipython impacket tqdm pytesseract pytest pyinstaller ropgadget pwntools flask pypykatz > /dev/null
    pipx install --quiet defaultcreds-cheat-sheet kerbrute > /dev/null
    pipx ensurepath > /dev/null
fi

# ------------------------------------- PYTHON2 & PIP2 ------------------------

if [[ "$pyp2" == "y" ]]; then
	info "[##] Installing Python2 & its Libraries -------------- [ TOOLS = 3 ]"
    apt-get -qq install -y python2 python2-dev python2-minimal
    curl -s https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip2.py && python2 get-pip2.py > /dev/null
fi

# ------------------------------------- DOCKER & WINE32 CONFIG ----------------

usermod -aG docker "$SUDO_USER"
dpkg --add-architecture i386 && apt-get -qq update && apt-get -qq install -y wine32

# ------------------------------------- GLOBAL GIT CONFIG ---------------------

if [[ "$gitx" == "y" ]]; then
	info "[##] Configuring GIT Configurations"
    git config --global user.name "Your Name"
    git config --global user.email "you@example.com"
    git config --global color.ui auto
fi

# ------------------------------------- NANORC MODIFICATIONS ------------------

if [[ "$nanorc_change" == "y" ]]; then
	info "[##] Performing NANO Configurations"
    [[ -f ./nanorc ]] && cp ./nanorc /etc/nanorc
    wget -q https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh -O- | sh 1>/dev/null
fi

# ------------------------------------- BASHRC CUSTOMIZATION ------------------

if [[ "$bashrc_change" == "y" ]]; then
	info "[##] Performing BASH Configurations"
    cp ./bashrc "/home/$SUDO_USER/.bashrc"
    cp ./bashrc /root/.bashrc
    warn "[#] Manual action needed: Please run 'source ~/.bashrc' after this script."
fi

# ------------------------------------- POST SETUP COMMMANDS ------------------

info "[###] Finalizing the PENTESTER'S KALI - LINUX Setup"
gzip -d /usr/share/wordlists/rockyou.txt.gz 2>/dev/null
searchsploit -u
nmap --script-updatedb > /dev/null
greenbone-nvt-sync --quiet
freshclam --quiet
apt-get -qq update
apt-get -qq upgrade -y
apt-get -qq full-upgrade -y
apt-get -qq autoremove -y
updatedb

# ------------------------------------- COMPLETION ----------------------------

echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"
echo -e "${GREEN}[###] Kali-Linux Pentest environment setup is finally complete!${NC}"
if [[ "$bashrc_change" == "y" ]]; then
	echo -e "${YELLOW}[###] Restart your terminal or run 'source ~/.bashrc' to apply all changes.${NC}"
fi
echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"
