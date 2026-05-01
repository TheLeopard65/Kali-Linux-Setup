#!/bin/bash
#Author: TheLeopard65

set -eo pipefail

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
success() { echo -e "${GREEN}[ OK ]${NC} $1"; }

if ! command -v figlet &> /dev/null; then
	apt-get update || true
	apt-get -qq install -y figlet &>/dev/null
fi

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
figlet "PENTESTER'S KALI - LINUX" || echo -e "${YELLOW}(Install 'figlet' to see ASCII banners)${NC}"
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"

export DEBIAN_FRONTEND=noninteractive
echo '* libraries/restart-without-asking boolean true' | debconf-set-selections

if [[ "$(id -u)" -ne 0 ]]; then
    error "Please run this script using ROOT or SUDO. (For example: 'sudo $0')!"
    exit 1
fi

TARGET_USER=${SUDO_USER:-$(whoami)}
TARGET_HOME=$(eval echo "~$TARGET_USER")
SCRIPT_DIR=$(dirname "$(realpath "$0")")

prompt_yes_no() {
    read -p "[#] $1 (Y/N) [default: N]: " reply
    reply=${reply:-N}
    echo "${reply,,}"
}

pipt=$(prompt_yes_no "1. Install pip3 & pipx tools? ----------")
pyp2=$(prompt_yes_no "2. Install Python2 & pip2 tools? -------")
penv=$(prompt_yes_no "3. Install Older Python3 Versions? -----")
snpd=$(prompt_yes_no "4. Install Snapd & Snap packages? ------")
gitx=$(prompt_yes_no "5. Add global Git configurations? ------")
w32s=$(prompt_yes_no "6. Enable support for Wine32 (I386)? ---")
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"

apt-get update
apt-get upgrade -y
apt-get full-upgrade -y

info "[##] Installing Compulsory/Required Tools ------------------------------------------------------------- [ TOOLS = 38 ]"
apt-get install -y wget curl whois openvpn wordlists seclists webshells exploitdb dpkg netcat-traditional ncat plocate git libffi-dev powershell eog \
metasploit-framework git-lfs build-essential firefox-esr docker.io docker-compose torbrowser-launcher ntpsec-ntpdate net-tools coreutils uuid axel \
xclip openssl flameshot dkms linux-headers-amd64 screenfetch tor git-all python3-setuptools snapd mono-devel libssl-dev mono-complete

info "[##] Installing Service-Specific Tools ---------------------------------------------------------------- [ TOOLS = 27 ]"
apt-get install -y smbclient enum4linux enum4linux-ng freerdp3-x11 rdesktop remmina evil-winrm sqlite3 default-mysql-server sqsh odat smbmap redis \
sqlmap onesixtyone nbtscan snmp snmpcheck samba samba-common-bin rpcbind kubectl mdbtools mongodb-clients ansible smtp-user-enum xtightvncviewer

info "[##] Installing Miscellaneous Tools ------------------------------------------------------------------- [ TOOLS = 27 ]"
apt-get install -y faketime binwalk steghide libimage-exiftool-perl zbar-tools pdf-parser foremost ffmpeg iptables cme pftools shellter gophish xxd \
autopsy powershell-empire ghostwriter pandoc dradis rlwrap liblnk-utils gemini-cli clamav-freshclam clamav jq xq gitleaks

info "[##] Installing Web Application Scanners -------------------------------------------------------------- [ TOOLS = 22 ]"
apt-get install -y gobuster ffuf wafw00f dirbuster dirsearch sublist3r feroxbuster wpscan openvas-scanner greenbone-feed-sync davtest sslyze nikto \
xsser burpsuite beef zaproxy shellfire evilginx2 cadaver wfuzz dirb

info "[##] Installing Active Directory Tools ---------------------------------------------------------------- [ TOOLS = 20 ]"
apt-get install -y bloodhound bloodhound.py certipy-ad responder ldap-utils lapsdumper gpp-decrypt bloodyad bloodhound-ce-python rubeus nishang \
krb5-user windows-binaries mimikatz powersploit laudanum netexec crackmapexec impacket-scripts peass

info "[##] Installing Port & Network Scanners --------------------------------------------------------------- [ TOOLS = 18 ]"
apt-get install -y nmap masscan unicornscan amass dnsenum dnsrecon netdiscover hping3 rizin sslh httprobe fping eyewitness elk-lapw wireshark tshark \
sniffglue tcpdump

info "[##] Installing Language & Support Tools -------------------------------------------------------------- [ TOOLS = 17 ]"
apt-get install -y python3 python3-dev python3-pip pipx npm nodejs postgresql libwine openjdk-11-jdk golang golang-go scapy php ruby rsync

info "[##] Installing Binary Exploitation Tools ------------------------------------------------------------- [ TOOLS = 14 ]"
apt-get install -y checksec ghidra pwncat radare2 gdb ltrace strace ollydbg binutils libc-bin jadx apktool adb poppler-utils

info "[##] Installing Password & Secrets Tools -------------------------------------------------------------- [ TOOLS = 11 ]"
apt-get install -y hashid john hashcat hydra medusa cewl cupp passwordsafe trufflehog trivy pacu

info "[##] Installing Pivoting & Tunneling Tools ------------------------------------------------------------- [ TOOLS = 8 ]"
apt-get install -y chisel ligolo-ng socat dnscat2 ptunnel sshuttle proxychains sshpass

info "[##] Installing Reconnaissance & Wireless Pentest Tools ------------------------------------------------ [ TOOLS = 8 ]"
apt-get install -y recon-ng sherlock theharvester linkedin2username aircrack-ng reaver wifite kismet-core

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"

info "[##] Installing Web, App & API Python3 Libraries ------------------------------------------------------ [ TOOLS = 12 ]"
apt-get install -y python3-flask python3-flask-socketio python3-flask-restful python3-bs4 python3-lxml python3-yaml python3-requests python3-pynput \
python3-pyqt5 python3-tk python3-pyautogui python3-selenium

info "[##] Installing Networking Python3 Libraries ---------------------------------------------------------- [ TOOLS = 12 ]"
apt-get install -y python3-paramiko python3-socketio python3-nmap python3-scapy python3-shodan python3-impacket python3-cryptography python3-requests \
python3-pycryptodome python3-ldap python3-corepywrap python3-bcrypt

info "[##] Installing Miscellaneous Python3 Libraries -------------------------------------------------------- [ TOOLS = 8 ]"
apt-get install -y python3-pwntools python3-ropgadget python3-geopy python3-colormap python3-termcolor python3-pil python3-pyftpdlib python3-capstone

info "[##] Installing AI/ML Python3 Libraries ---------------------------------------------------------------- [ TOOLS = 7 ]"
apt-get install -y python3-numpy python3-pandas python3-matplotlib python3-opencv python3-soundfile python3-pydantic python3-sqlalchemy

if [[ "$pipt" == "y" ]]; then
	info "[##] Installing Important PIPX Tools ------------------------------------------------------------------ [ TOOLS = 23 ]"
	for pkg in websocket-client pwnedpasswords geocoder ipython impacket tqdm pytesseract pytest pyinstaller ropgadget pypykatz cheroot wesng defaultcreds-cheat-sheet kerbrute pywhisker droopescan uploadserver wsgidav xsstrike bloodhound pwntools flask shell-gpt; do
		pipx install --quiet "$pkg"
	done
	pipx ensurepath
fi

if [[ "$pyp2" == "y" ]]; then
	info "[##] Installing Python2 & its Libraries ---------------------------------------------------------------- [ TOOLS = 3 ]"
	apt-get install -y python2 python2-dev python2-minimal
	curl -s https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip2.py && python2 get-pip2.py
fi

if [[ "$penv" == "y" ]]; then
    info "[##] Installing Older versions of Python3 -------------------------------------------------------------- [ TOOLS = 1 ]"
    apt-get install -y pyenv
    PYENV_USER="${SUDO_USER:-$(logname)}"
    PYENV_HOME=$(eval echo "~$PYENV_USER")
    PY_VERSIONS=( "3.11.11" "3.10.16" "3.8.20" )
    info "[##] Installing pyenv python builds into ${PYENV_USER}'s home: ${PYENV_HOME}/.pyenv"
    run_as_target() {
        sudo -u "$PYENV_USER" -H bash -lc "export HOME='$PYENV_HOME'; export PYENV_ROOT=\"\$HOME/.pyenv\"; export PATH=\"\$PYENV_ROOT/bin:\$PATH\"; mkdir -p \"\$PYENV_ROOT\"; $*"
    }
    mkdir -p "$PYENV_HOME/.pyenv"
    chown -R "$PYENV_USER":"$PYENV_USER" "$PYENV_HOME/.pyenv" || true
    for ver in "${PY_VERSIONS[@]}"; do
        info "[##] Checking for Python $ver for user $PYENV_USER ..."
        if run_as_target "pyenv versions --bare 2>/dev/null | grep -xqF '$ver'"; then
            info "[##] pyenv: $ver already installed for $PYENV_USER - skipping."
            continue
        fi
        info "[##] pyenv: Installing $ver for $PYENV_USER ..."
        if run_as_target "pyenv install -s '$ver'"; then
            success "pyenv: $ver installed for $PYENV_USER."
        else
            warn "pyenv: installation of $ver for $PYENV_USER failed — continuing with next version."
        fi
        chown -R "$PYENV_USER":"$PYENV_USER" "$PYENV_HOME/.pyenv" || true
    done
fi

if [[ "$snpd" == "y" ]]; then
	info "[##] Installing Snapd & its packages ------------------------------------------------------------------- [ TOOLS = 4 ]"
	systemctl enable --now snapd
fi

if [[ "$w32s" == "y" ]]; then
	info "[##] Enabling the 32-Bit Architecture --------------------------------------------------------------------- [ MANUAL ]"
    dpkg --add-architecture i386
    apt-get update
    apt-get install -f -y
    if ! apt-get install -y wine32; then
        warn "[!!!] Wine32 failed due to repo mismatch."
        warn "[!!!] Run: apt full-upgrade -y then retry."
    fi
fi

if [[ "$gitx" == "y" ]]; then
	info "[##] Configuring GIT Configurations ----------------------------------------------------------------------- [ MANUAL ]"
	read -p ">>>[#] Please Enter your GitHub/GitLab Username: " git_username
	read -p ">>>[#] Please Enter your GitHub/GitLab Email: " git_email
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global color.ui auto
fi

info "[###] Finalizing the PENTESTER'S KALI - LINUX Setup ------------------------------------------------------- [ MANUAL ]"

if [[ -f /usr/share/wordlists/rockyou.txt.gz ]]; then
    gzip -d /usr/share/wordlists/rockyou.txt.gz 2>/dev/null
fi

usermod -aG docker "$TARGET_USER"
searchsploit -u
nmap --script-updatedb
apt-get update
apt-get full-upgrade -y
apt-get autoremove -y
updatedb
unset DEBIAN_FRONTEND

info "[###] Deactivating the automatic Time Setup via Host-Time ------------------------------------------------- [ MANUAL ]"

systemctl stop virtualbox-guest-utils || true
systemctl disable --now systemd-timesyncd

if groups "$TARGET_USER" | grep -q '\bdocker\b'; then
    echo -e "${YELLOW}[###] You may need to LOG OUT and back in to apply DOCKER group membership.${NC}"
fi

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
echo -e "${GREEN}[###] Kali-Linux Pentester's Environment setup is finally complete!${NC}"
echo -e "${RED}[###] Please Restart/Reboot your System for some of the changes to take Effect.!!!${NC}"
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
