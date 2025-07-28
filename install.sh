#!/bin/bash
#Author: TheLeopard65

# Checking if user is root
if [ $(whoami) != "root" ]; then
    echo "SYNTAX: PLEASE RUN THIS SCRIPT WITH SUDO PRIVILEGES !!"
    exit 1
fi

if [ -z "$SUDO_USER" ]; then
    echo "Error: This script must be run using sudo (not directly as root)."
    exit 1
fi

echo "[###@] STARTING WSL2 KALI-LINUX SETUP (DEVELOPED BY @TheLeopard65) [@###]"
echo "[#] BEFORE PROCEEDING FURTHER, MAKE SURE TO THOROUGHLY ANALYZE THE CODE [#]"

# Prompting for user input with default as "N" (No) and case-insensitive comparison
read -p "[#] DO YOU WANT TO INSTALL OPTIONAL TOOLS? (Y/N) [default: N] : " optx
optx=${optx:-N}  # Default to "N" if no input is provided
optx=$(echo "$optx" | tr '[:upper:]' '[:lower:]')  # Convert to lowercase

read -p "[#] DO YOU WANT TO INSTALL GUI-BASED TOOLS? (Y/N) [default: N] : " guix
guix=${guix:-N}
guix=$(echo "$guix" | tr '[:upper:]' '[:lower:]')

read -p "[#] DO YOU WANT TO INSTALL PIP3 & PIPX TOOLS? (Y/N) [default: N] : " pipt
pipt=${pipt:-N}
pipt=$(echo "$pipt" | tr '[:upper:]' '[:lower:]')

read -p "[#] DO YOU WANT TO INSTALL PYTHON2 & PIP2 TOOLS? (Y/N) [default: N] : " pyp2
pyp2=${pyp2:-N}
pyp2=$(echo "$pyp2" | tr '[:upper:]' '[:lower:]')

read -p "[#] DO YOU WANT TO INSTALL NON-APT REPO TOOLS? (Y/N) [default: N] : " napt
napt=${napt:-N}
napt=$(echo "$napt" | tr '[:upper:]' '[:lower:]')

read -p "[#] DO YOU WANT TO INSTALL DOCKER MANAGER TOOLS? (Y/N) [default: N] : " dock
dock=${dock:-N}
dock=$(echo "$dock" | tr '[:upper:]' '[:lower:]')

read -p "[#] DO YOU WANT TO ADD GLOBAL LEVEL GIT CONFIGURATIONS? (Y/N) [default: N] : " gitx
gitx=${gitx:-N}
gitx=$(echo "$gitx" | tr '[:upper:]' '[:lower:]')

read -p "[#] DO YOU WANT TO ENABLE THE SYSTEMD (DAEMON) FOR SERVICES? (Y/N) [default: N] : " sysd
sysd=${sysd:-N}
sysd=$(echo "$sysd" | tr '[:upper:]' '[:lower:]')

read -p "[#] DO YOU WANT TO CHANGE BASHRC FILE FOR BETTER USAGE WITH MOUSE? (Y/N) [default: N] : " bashrc_change
bashrc_change=${bashrc_change:-N}
bashrc_change=$(echo "$bashrc_change" | tr '[:upper:]' '[:lower:]')

read -p "[#] DO YOU WANT TO CHANGE NANORC FILE FOR BETTER & EASIER USAGE? (Y/N) [default: N] : " nanorc_change
nanorc_change=${nanorc_change:-N}
nanorc_change=$(echo "$nanorc_change" | tr '[:upper:]' '[:lower:]')

# Updating and Upgrading for the WSL2 & Installing Normal CLI Kali specific Tools Installed for Pentesting and PWN/BIN/Reverse/WEB
apt-get update -y && apt-get upgrade -y
apt install -y wget curl whois openvpn wordlists webshells seclists exploitdb nmap dpkg gobuster john hydra hashcat python3 sqlmap netcat-traditional metasploit-framework nikto checksec git git-all plocate build-essential bloodhound wpscan hashid powershell smbclient pwncat enum4linux freerdp3-x11 npm nodejs postgresql crackmapexec impacket-scripts evil-winrm firefox-esr
apt install -y windows-binaries netdiscover chisel ncat git-lfs python3-dev libssl-dev libwine cewl radare2 mimikatz wfuzz ffuf jadx apktool faketime binwalk steghide sublist3r feroxbuster libimage-exiftool-perl openjdk-11-jdk zbar-tools pdf-parser foremost ffmpeg iptables cme python3-pip pipx davtest cadaver sqlite3 default-mysql-server ltrace strace dirbuster
apt install -y python3-requests python3-pycryptodome python3-pwntools bloodhound.py powersploit ligolo-ng socat net-tools scapy smbmap certipy-ad rubeus docker.io docker-compose golang golang-go

# OPTIONAL: Installing The tools are not necessarily used every day
if [[ "$optx" == "y" ]]; then
    apt install -y libffi-dev amass openvas-scanner trufflehog trivy responder pacu evilginx2 adb dnsenum sniffglue rizin sslh dnsrecon httprobe sslyze unicornscan pompem pftools bash-completion snapd nbtscan tshark shellter xsser wafw00f recon-ng aircrack-ng sherlock theharvester hping3 dirsearch masscan reaver wifite
fi

# OPTIONAL: Installing GUI-Based Tools (These should be installed on Windows itself for better performance)
if [[ "$guix" == "y" ]]; then
    apt install -y terminator burpsuite ghidra wireshark tor torbrowser-launcher clamav eog autopsy maltego ollydbg kismet-core beef gophish powershell-empire
    greenbone-nvt-sync
    freshclam
fi

# OPTIONAL: Installing important pips
if [[ "$pipt" == "y" ]]; then
    apt install -y python3-flask python3-flask-socketio python3-bcrypt python3-flask-restful python3-bs4 python3-numpy python3-pandas python3-matplotlib python3-paramiko python3-socketio python3-nmap python3-lxml python3-selenium python3-yaml python3-geopy python3-colormap python3-termcolor
    apt install -y python3-tk python3-pydantic python3-cryptography python3-sqlalchemy python3-opencv python3-pil python3-pyautogui python3-soundfile python3-pynput python3-capstone python3-corepywrap python3-impacket python3-ropgadget python3-scapy python3-shodan python3-pyqt5
    pipx install websocket-client pwnedpasswords geocoder ipython impacket tqdm pytesseract pytest pyinstaller ropgadget pwntools flask kerbrute
fi

if [[ "$pyp2" == "y" ]]; then
	apt install -y python2 python2-dev python2-minimal
	python2 ./get-pip2.py
fi

# OPTIONAL: Setting up your Git and Github Configurations Globally. (MAKE SURE TO CHANGE THE CONFIGURATIONS BELOW)
if [[ "$gitx" == "y" ]]; then
    git config --global user.name "<GITHUB-USERNAME>"
    git config --global user.email "<GITHUB-USED-EMAIL@gmail.com>"
    git config --global init.defaultBranch main
fi

if [[ "$sysd" == "y" ]]; then
    # ADD-ON: Setting Up Systemd for service controls & snapd
    if [ ! -f /etc/wsl.conf ] || ! grep -q "systemd=true" /etc/wsl.conf; then
        if [ ! -f /etc/wsl.conf ]; then
            touch /etc/wsl.conf
        fi
        echo "[boot]" >> /etc/wsl.conf
        echo "systemd=true" >> /etc/wsl.conf
        systemctl enable snapd
        echo "[#] Please Exit the WSL and the Following Commands on the CMD."
        echo "powershell.exe wsl --update"
        echo "powershell.exe wsl --shutdown"
        echo "[#] Then, Restart WSL and re-run \"setupmywsl.sh\" script."
        exit 0
    fi
    systemctl enable snapd
    systemctl enable postgresql
fi

# OPTIONAL: INSTALLING DOCKER ON THE WSL2 KALI-LINUX SYSTEM
if [[ "$dock" == "y" ]]; then
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt --purge remove -y $pkg; done
    apt update -y && apt upgrade -y && apt install ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt update -y && apt upgrade -y
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# Enabling 32-Bit Packages
dpkg --add-architecture i386
apt update
apt -y install wine32

# COMPULSORY: UPDATING SOME IMPORTANT DATABASES
gzip -d /usr/share/wordlists/rockyou.txt.gz
searchsploit -u
nmap --script-updatedb
pipx ensurepath
usermod -aG docker $SUDO_USER

# Making Nano shortcuts and experience more windows-like:
if [[ "$nanorc_change" == "y" ]]; then
    cp ./nanorc /etc/nanorc
fi

# Enabling Syntax Highlighting in Nano
wget https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh -O- | sh

# Making Terminal like compact and custom:
if [[ "$bashrc_change" == "y" ]]; then
    cp ./bashrc /home/$SUDO_USER/.bashrc
    cp ./bashrc /root/.bashrc
    source ~/.bashrc      # This won't work. You might have to source it manually after script finihes.
fi

if [[ "$napt" == "y" ]]; then
	mkdir -p /opt
	chown -R $SUDO_USER /opt
    apt-get update -y && apt-get upgrade -y

    # Installing GDB-GEF for GDB
    bash -c "$(curl -fsSL https://gef.blah.cat/sh)"

	# Installing Sysrepter
	bash <(curl -s https://docs.sysreptor.com/install.sh)

    # Installing Ipinfo-CLI && Wayback-Curls
    cd /opt
    curl -Ls https://github.com/ipinfo/cli/releases/download/ipinfo-3.3.1/deb.sh | sh
    go install github.com/tomnomnom/waybackurls@latest

    # Installing CloudSploit
    cd /opt
    git clone https://github.com/aquasecurity/cloudsploit.git
    cd cloudsploit
    npm install
    ./index.js -h

    # Installing LinkFinder
    cd /opt
    git clone https://github.com/GerbenJavado/LinkFinder.git
    cd LinkFinder
    python setup.py install

    # Installing NESSUS
    cd /var/cache/apt/archive/
    wget -O nessus.deb https://www.tenable.com/downloads/api/v1/public/pages/nessus/downloads/11671/download?i_agree_to_tenable_license_agreement=true
    dpkg -i nessus.deb

    # Installing DEEPSOUND
    cd /opt
    wget -O /opt/deepsound.msi http://jpinsoft.net/DeepSound/Download.aspx?Download=LastVersion
    wine msiexec /i /opt/deepsound.msi

    # Installing SSTV Decoder
    cd /opt
    git clone https://github.com/colaclanth/sstv.git
    cd sstv
    python3 setup.py install

    # Installing Volatility3
    cd /opt
    git clone https://github.com/volatilityfoundation/volatility3.git
    cd volatility3
    python3 setup.py build
    python3 setup.py install
fi

# Final Update and Upgrade
apt-get update -y && apt-get upgrade -y
apt-get full-upgrade -y
apt-get autoremove -y
updatedb

# Move to Home Directory
clear
cd
echo "[#] Please restart your terminal or manually source ~/.bashrc to apply changes."
