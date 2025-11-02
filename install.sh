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

TARGET_USER=${SUDO_USER:-$(logname)}
TARGET_HOME=$(eval echo "~$TARGET_USER")

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
desk=$(prompt_yes_no "9. Customize my XFCE4 Desktop Apps? -")
echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"

# ------------------------------------- SYSTEM UPDATES ------------------------

info "[###] Updating & upgrading system..."
apt-get -qq update && apt-get -qq upgrade -y

# ------------------------------------- TOOLS INSTALLATION --------------------

info "[##] Installing Compulsory/Required Tools --------------- [ TOOLS = 37 ]"
apt-get -qq install -y wget curl whois openvpn wordlists seclists webshells exploitdb dpkg netcat-traditional ncat plocate git libffi-dev snapd git-all > /dev/null
apt-get -qq install -y metasploit-framework powershell git-lfs build-essential firefox-esr docker.io docker-compose libssl-dev torbrowser-launcher > /dev/null
apt-get -qq install -y coreutils uuid ntpsec-ntpdate axel xclip openssl flameshot dkms linux-headers-$(uname -r) screenfetch tor eog net-tools > /dev/null

info "[##] Installing Service-Specific Tools ------------------ [ TOOLS = 27 ]"
apt-get -qq install -y smbclient enum4linux enum4linux-ng freerdp3-x11 rdesktop remmina evil-winrm sqlite3 default-mysql-server sqsh odat smtp-user-enum > /dev/null
apt-get -qq install -y sqlmap onesixtyone nbtscan snmp snmpcheck samba samba-common-bin rpcbind kubectl mdbtools xtightvncviewer mongodb-clients ansible > /dev/null
apt-get -qq install -q smbmap redis > /dev/null

info "[##] Installing Web Application Scanners ---------------- [ TOOLS = 22 ]"
apt-get -qq install -y gobuster ffuf wafw00f dirbuster dirsearch sublist3r feroxbuster wpscan openvas-scanner greenbone-feed-sync sslyze nikto davtest > /dev/null
apt-get -qq install -y xsser burpsuite beef zaproxy shellfire dirb evilginx2 cadaver wfuzz > /dev/null

info "[##] Installing Miscellaneous Tools --------------------- [ TOOLS = 22 ]"
apt-get -qq install -y faketime binwalk steghide libimage-exiftool-perl zbar-tools pdf-parser foremost ffmpeg iptables cme pftools shellter gophish xxd > /dev/null
apt-get -qq install -y autopsy powershell-empire ghostwriter pandoc dradis rlwrap liblnk-utils gemini-cli clamav-freshclam clamav jq xq > /dev/null

info "[##] Installing Language & Support Tools ---------------- [ TOOLS = 17 ]"
apt-get -qq install -y python3 python3-dev python3-pip pipx npm nodejs postgresql libwine openjdk-11-jdk golang golang-go scapy bash-completion php ruby > /dev/null
apt-get -qq install -y php rsync > /dev/null

info "[##] Installing Port & Network Scanners ----------------- [ TOOLS = 14 ]"
apt-get -qq install -y nmap masscan unicornscan amass dnsenum dnsrecon netdiscover hping3 rizin sslh httprobe fping eyewitness elk-lapw > /dev/null

info "[##] Installing Binary Exploitation Tools --------------- [ TOOLS = 10 ]"
apt-get -qq install -y checksec ghidra pwncat radare2 gdb ltrace strace ollydbg binutils libc-bin > /dev/null

info "[##] Installing Active Directory Tools ------------------- [ TOOLS = 9 ]"
apt-get -qq install -y bloodhound bloodhound.py certipy-ad responder ldap-utils lapsdumper gpp-decrypt bloodyad bloodhound-ce-python krb5-user > /dev/null

info "[##] Installing Password Cracking Tools ------------------ [ TOOLS = 7 ]"
apt-get -qq install -y hashid john hashcat hydra medusa cewl cupp passwordsafe > /dev/null

info "[##] Installing Windows-Specific Tools ------------------- [ TOOLS = 7 ]"
apt-get -qq install -y windows-binaries mimikatz rubeus nishang powersploit laudanum peass > /dev/null

info "[##] Installing Pivoting & Tunneling Tools --------------- [ TOOLS = 7 ]"
apt-get -qq install -y chisel ligolo-ng socat dnscat2 ptunnel sshuttle proxychains sshpass > /dev/null

info "[##] Installing Exploitation Tools ----------------------- [ TOOLS = 5 ]"
apt-get -qq install -y netexec crackmapexec impacket-scripts pompem sliver > /dev/null

info "[##] Installing Creds & Cloud Scan Tools ----------------- [ TOOLS = 3 ]"
apt-get -qq install -y trufflehog trivy pacu > /dev/null

info "[##] Installing Network Traffic Tools -------------------- [ TOOLS = 4 ]"
apt-get -qq install -y wireshark tshark sniffglue tcpdump > /dev/null

info "[##] Installing Mobile APK Analysis Tools ---------------- [ TOOLS = 4 ]"
apt-get -qq install -y jadx apktool adb poppler-utils > /dev/null

info "[##] Installing Reconnaissance Tools --------------------- [ TOOLS = 5 ]"
apt-get -qq install -y recon-ng sherlock theharvester linkedin2username gitleaks > /dev/null

info "[##] Installing Wireless Pentest Tools ------------------- [ TOOLS = 4 ]"
apt-get -qq install -y aircrack-ng reaver wifite kismet-core > /dev/null

# ------------------------------------- PYTHON3 LIBRARIES ---------------------

echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"
info "[##] Installing Web, App & API Python3 Libraries -------- [ TOOLS = 12 ]"
apt-get -qq install -y python3-flask python3-flask-socketio python3-flask-restful python3-bs4 python3-lxml python3-yaml python3-requests python3-selenium > /dev/null
apt-get -qq install -y python3-pyqt5 python3-tk python3-pynput python3-pyautogui > /dev/null

info "[##] Installing Networking Python3 Libraries ------------ [ TOOLS = 12 ]"
apt-get -qq install -y python3-paramiko python3-socketio python3-nmap python3-scapy python3-shodan python3-impacket python3-bcrypt python3-cryptography > /dev/null
apt-get -qq install -y python3-pycryptodome python3-ldap python3-corepywrap python3-requests

info "[##] Installing Miscellaneous Python3 Libraries ---------- [ TOOLS = 8 ]"
apt-get -qq install -y python3-pwntools python3-ropgadget python3-geopy python3-colormap python3-termcolor python3-pil python3-capstone python3-pyftpdlib > /dev/null

info "[##] Installing AI/ML Python3 Libraries ------------------ [ TOOLS = 7 ]"
apt-get -qq install -y python3-numpy python3-pandas python3-matplotlib python3-opencv python3-soundfile python3-pydantic python3-sqlalchemy > /dev/null

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
	apt-get -qq install -y python2 python2-dev python2-minimal > /dev/null
	curl -s https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip2.py && python2 get-pip2.py > /dev/null
fi


if [[ "$penv" == "y" ]]; then
    info "[##] Installing Older versions of Python3 ---------------- [ TOOLS = 1 ]"
    apt-get -qq install -y pyenv > /dev/null
    TARGET_USER="${SUDO_USER:-$(logname)}"
    TARGET_HOME=$(eval echo "~$TARGET_USER")
    PY_VERSIONS=( "3.11.11" "3.10.16" "3.8.20" )
    info "[##] Installing pyenv python builds into ${TARGET_USER}'s home: ${TARGET_HOME}/.pyenv"
    run_as_target() {
        sudo -u "$TARGET_USER" -H bash -lc "export HOME='$TARGET_HOME'; export PYENV_ROOT=\"\$HOME/.pyenv\"; export PATH=\"\$PYENV_ROOT/bin:\$PATH\"; mkdir -p \"\$PYENV_ROOT\"; $*"
    }
    mkdir -p "$TARGET_HOME/.pyenv"
    chown -R "$TARGET_USER":"$TARGET_USER" "$TARGET_HOME/.pyenv" || true
    for ver in "${PY_VERSIONS[@]}"; do
        info "[##] Checking for Python $ver for user $TARGET_USER ..."
        if run_as_target "pyenv versions --bare 2>/dev/null | grep -xqF '$ver'"; then
            info "[##] pyenv: $ver already installed for $TARGET_USER — skipping."
            continue
        fi
        info "[##] pyenv: Installing $ver for $TARGET_USER ..."
        if run_as_target "pyenv install -s '$ver'"; then
            success "pyenv: $ver installed for $TARGET_USER."
        else
            warn "pyenv: installation of $ver for $TARGET_USER failed — continuing with next version."
        fi
        chown -R "$TARGET_USER":"$TARGET_USER" "$TARGET_HOME/.pyenv" || true
    done
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

usermod -aG docker "$TARGET_USER"
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
        cp ./resources/bashrc "${TARGET_HOME}/.bashrc"
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
        cp ./resources/zshrc "${TARGET_HOME}/.zshrc"
        cp ./resources/zshrc /root/.zshrc
        warn "[#] Manual action needed: Please run 'source ~/.zshrc' after this script."
    else
        warn "[!!!] zshrc file not found in current directory, skipping copy."
    fi
fi

# ------------------------------------- PANEL CUSTOMIZATION -------------------

if [[ "$desk" == "y" ]]; then
    info "[##] Performing XFCE Customizations ------------------------- [ MANUAL ]"
    if [[ -d ./resources/.config ]]; then
    	rm -rf "${TARGET_HOME}/.config"
        cp -rpa ./resources/.config "${TARGET_HOME}/"
    else
        warn "[!!!] .config directory not found in current directory, skipping copy."
    fi
fi

# ------------------------------------- POST SETUP COMMANDS -------------------

info "[###] Finalizing the PENTESTER'S KALI - LINUX Setup --------- [ MANUAL ]"

if [[ -f /usr/share/wordlists/rockyou.txt.gz ]]; then
    gzip -d /usr/share/wordlists/rockyou.txt.gz 2>/dev/null
fi

searchsploit -u > /dev/null
nmap --script-updatedb > /dev/null
apt-get -qq update
apt-get -qq upgrade -y
apt-get -qq full-upgrade -y
apt-get -qq autoremove -y
updatedb
unset DEBIAN_FRONTEND

# ------------------------------------- DIR SETUP & SSH KEY -------------------

info "[###] Setting up the User's Home Directory ------------------ [ MANUAL ]"

cd "/home/$TARGET_USER/" && mkdir -p {recon,loot,exploits,transfer,creds/hashes,tools,misc,CTF/{rev,pwn,web,misc,crypto,forensics},OpenVPN}
touch "/home/$TARGET_USER/creds/credentials.txt"
SSH_KEY="/home/$TARGET_USER/creds/ssh-key"

if [[ ! -f "$SSH_KEY" ]]; then
	cd /home/$TARGET_USER/creds/
    ssh-keygen -t ed25519 -f "$SSH_KEY" -N "" -q
    chmod 600 "$SSH_KEY"
	chmod 644 "$SSH_KEY.pub"
	cd ..
fi
sudo chown -R $TARGET_USER:$TARGET_USER /home/$TARGET_USER/{recon,loot,exploits,transfer,tools,misc,creds,CTF,OpenVPN,.config}

# ------------------------------------- COMPLETION ----------------------------

echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"
echo -e "${GREEN}[###] Kali-Linux Pentest environment setup is finally complete!${NC}"
if [[ "$barc" == "y" ]]; then
	echo -e "${YELLOW}[###] Restart your terminal or run 'source ~/.bashrc' to apply all changes.${NC}"
fi
if groups "$TARGET_USER" | grep -q '\bdocker\b'; then
    echo -e "${YELLOW}[###] You may need to LOG OUT and back in to apply DOCKER group membership.${NC}"
fi
echo -e "${RED}[###] Please Restart/Reboot your System for some of the changes to take Effect.!!!${NC}"
echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"
screenfetch
echo -e "${GREEN}[###] -------------------------------------------------- [###]${NC}"
