#!/bin/bash
#Author: TheLeopard65

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

if [[ "$(id -u)" -ne 0 ]]; then
    error "Please run this script using ROOT or SUDO. (For example: 'sudo $0')!"
    exit 1
fi

apt-get -qq install figlet -y
clear
echo "[###] STARTING THE PENTESTER'S KALI - LINUX UPDATE SETUP [###]"
figlet "PENTESTER'S KALI - LINUX"
echo "[###] -------------------------------------------------- [###]"

set -euo pipefail
DIR=$(eval echo "~$SUDO_USER")/IMP-TOOLS
mkdir -p "$DIR"
apt-get -qq install -y git zip gzip unzip wget ruby-dev make python3

# ------------------------------------- LINUX TOOLS ---------------------------

linux_scripts() {
    echo "[###] DOWNLOADING LINUX SCRIPTS ------------------------------------------------------ ( Total Tools = 18 ) [###]"
    cd "$DIR" && mkdir -p linux-scripts && cd linux-scripts

    info "[1] Downloading LinEnum Script" && wget -q https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -O LinEnum.sh && chmod +x LinEnum.sh
    info "[2] Downloading bashark Script" && wget -q https://raw.githubusercontent.com/redcode-labs/Bashark/refs/heads/master/bashark.sh -O bashark.sh && chmod +x bashark.sh
    info "[3] Downloading username-anarchy tool" && wget -q https://raw.githubusercontent.com/urbanadventurer/username-anarchy/refs/heads/master/username-anarchy && chmod +x username-anarchy
    info "[4] Downloading keytabextract.py tool" && wget -q https://raw.githubusercontent.com/sosdave/KeyTabExtract/refs/heads/master/keytabextract.py -O keytabextract.py && chmod +x keytabextract.py
    info "[5] Downloading Linux-exploit-suggester" && wget -q https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh -O linux-exploit-suggester.sh && chmod +x linux-exploit-suggester.sh
    info "[6] Downloading Linux-exploit-suggester-2" && wget -q https://raw.githubusercontent.com/jondonas/linux-exploit-suggester-2/master/linux-exploit-suggester-2.pl -O linux-exploit-suggester-2.pl && chmod +x linux-exploit-suggester-2.pl
    info "[7] Downloading XXEinjector" && wget -q https://raw.githubusercontent.com/enjoiz/XXEinjector/refs/heads/master/XXEinjector.rb -O XXEinjector.rb && chmod +x XXEinjector.rb && ln -s $DIR/linux-scripts/XXEinjector.rb /usr/local/bin/XXEinjector
    info "[8] Downloading Windows Exploit Suggester" && wget -q https://raw.githubusercontent.com/Pwnistry/Windows-Exploit-Suggester-python3/refs/heads/master/windows-exploit-suggester.py -O windows-exploit-suggester.py && chmod +x windows-exploit-suggester.py
    info "[9] Downloading pspy64" && wget -q https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 -O pspy64 && chmod +x pspy64
    info "[10] Downloading linpeas" && wget -q https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -O linpeas.sh && chmod +x linpeas.sh
    info "[11] Downloading chisel-linux" && wget -q https://github.com/jpillora/chisel/releases/download/v1.10.1/chisel_1.10.1_linux_amd64.gz -O chisel-linux.gz && gunzip chisel-linux.gz && chmod +x chisel-linux
    info "[12] Downloading kerbrute" && wget -q https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64 -O kerbrute && chmod +x kerbrute && ln -s $DIR/linux-scripts/kerbrute /usr/local/bin/kerbrute

    info "[13] Downloading ligolo-NG Tools"
	mkdir -p ligolo-tools && cd ligolo-tools
	    wget -q https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.2/ligolo-ng_proxy_0.8.2_linux_amd64.tar.gz -O ligolo-proxy.tar.gz && tar -xzf ligolo-proxy.tar.gz && rm -rf LICENSE README.md ligolo-proxy.tar.gz && mv proxy ligolo-proxy
	    wget -q https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.2/ligolo-ng_agent_0.8.2_linux_amd64.tar.gz -O ligolo-agent.tar.gz && tar -xzf ligolo-agent.tar.gz  && rm -rf LICENSE README.md ligolo-agent.tar.gz && mv agent ligolo-agent
	cd ..

	info "[14] Downloading kiterunner" && wget -q https://github.com/assetnote/kiterunner/releases/download/v1.0.2/kiterunner_1.0.2_linux_amd64.tar.gz -O kiterunner-1.0.2.tar.gz && tar -xzf kiterunner-1.0.2.tar.gz && ln -s $DIR/linux-scripts/kr /usr/local/bin/kr && rm kiterunner-1.0.2.tar.gz
    info "[15] Downloading mimipenguin" && wget -q https://github.com/huntergregal/mimipenguin/releases/download/2.0-release/mimipenguin_2.0-release.tar.gz -O mimipenguin-2.0.tar.gz && tar -xzf mimipenguin-2.0.tar.gz && mv mimipenguin_2.0-release mimipenguin-2.0 && rm -f mimipenguin-2.0.tar.gz
    info "[16] Cloning Linux Kernel Exploits Repository" && git clone --quiet https://github.com/JlSakuya/Linux-Privilege-Escalation-Exploits.git
    info "[17] Cloning SUDO_KILLER Repository" && git clone --quiet https://github.com/TH3xACE/SUDO_KILLER.git
    info "[18] Cloning Rpivot Repository" && git clone --quiet https://github.com/klsecservices/rpivot.git

    echo "[###] LINUX TOOLS DOWNLOAD COMPLETE [###]"
}

# ------------------------------------- WINDOWS TOOLS -------------------------

windows_scripts() {
    echo "[###] DOWNLOADING WINDOWS SCRIPTS ---------------------------------------------------- ( Total Tools = 20 ) [###]"
    cd "$DIR" && mkdir -p windows-scripts && cd windows-scripts

    info "[1] Downloading JAWS Script" && wget -q https://raw.githubusercontent.com/411Hall/JAWS/master/jaws-enum.ps1 -O jaws-enum.ps1
    info "[2] Downloading Sherlock" && wget -q https://raw.githubusercontent.com/rasta-mouse/Sherlock/master/Sherlock.ps1 -O Sherlock.ps1
    info "[3] Downloading ADRecon" && wget -q https://raw.githubusercontent.com/adrecon/ADRecon/refs/heads/master/ADRecon.ps1 -O ADRecon.ps1
    info "[4] Downloading LAPSToolkit" && wget -q https://raw.githubusercontent.com/leoloobeek/LAPSToolkit/refs/heads/master/LAPSToolkit.ps1 -O LAPSToolkit.ps1
    info "[5] Downloading dnscat2.ps1" && wget -q https://raw.githubusercontent.com/lukebaggett/dnscat2-powershell/refs/heads/master/dnscat2.ps1 -O dnscat2.ps1
    info "[6] Downloading DomainPasswordSpray" && wget -q https://raw.githubusercontent.com/dafthack/DomainPasswordSpray/refs/heads/master/DomainPasswordSpray.ps1 -O DomainPasswordSpray.ps1
    info "[7] Downloading Invoke-DOSfuscation" && wget -q https://raw.githubusercontent.com/danielbohannon/Invoke-DOSfuscation/refs/heads/master/Invoke-DOSfuscation.psd1 -O Invoke-DOSfuscation.psd1
    info "[8] Downloading TargetedKerberoast.py" && wget -q https://raw.githubusercontent.com/ShutdownRepo/targetedKerberoast/refs/heads/main/targetedKerberoast.py -O targetedKerberoast.py && ln -s $DIR/windows-scripts/targetedKerberoast.py /usr/local/bin/targetedKerberoast.py
    info "[9] Downloading LaZagne.exe" && wget -q https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.7/LaZagne.exe -O LaZagne.exe
    info "[10] Downloading Snaffler.exe" && wget -q https://github.com/SnaffCon/Snaffler/releases/download/1.0.212/Snaffler.exe -O Snaffler.exe
    info "[11] Downloading Rpivot Client" && wget -q https://github.com/klsecservices/rpivot/releases/download/v1.0/client.exe -O rpivot-client.exe
    info "[12] Downloading winPEASany" && wget -q https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany.exe -O winPEASany.exe
    info "[13] Downloading SharpView.exe" && wget -q https://github.com/tevora-threat/SharpView/raw/refs/heads/master/Compiled/SharpView.exe -O SharpView.exe
    info "[14] Downloading chisel-windows" && wget -q https://github.com/jpillora/chisel/releases/download/v1.10.1/chisel_1.10.1_windows_amd64.gz -O chisel-windows.1.10.1.gz && gunzip chisel-windows.1.10.1.gz && mv chisel-windows.1.10.1 chisel-windows-1.10.1.exe
    info "[15] Downloading ligolo-agent" && wget -q https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.2/ligolo-ng_agent_0.8.2_windows_amd64.zip -O ligolo-Agent.zip && unzip -qq ligolo-Agent.zip && rm -f ligolo-Agent.zip LICENSE README.md && mv agent.exe ligolo-agent.exe

    info "[16] Downloading Inveigh Tools"
    mkdir -p inveigh-tools && cd inveigh-tools
        wget -q https://github.com/Kevin-Robertson/Inveigh/releases/download/v2.0.11/Inveigh-net8.0-win-x64-trimmed-single-v2.0.11.zip -O Inveigh-Net8-Win-2.0.11.zip
        unzip -qq Inveigh-Net8-Win-2.0.11.zip && rm -f Inveigh.pdb Inveigh-Net8-Win-2.0.11.zip
        wget -q https://raw.githubusercontent.com/Kevin-Robertson/Inveigh/refs/heads/master/Inveigh.ps1
    cd ..

    info "[17] Downloading socat windows"
    mkdir -p socat-windows && cd socat-windows
        wget -q https://github.com/3ndG4me/socat/releases/download/v1.7.3.3/socatx64.exe -O socatx64.exe
        wget -q https://github.com/3ndG4me/socat/releases/download/v1.7.3.3/socatx86.exe -O socatx86.exe
    cd ..

    info "[18] Downloading UACME - Akagi"
    mkdir -p UACME-Akagi && cd UACME-Akagi
        wget -q https://github.com/yuyudhn/UACME-bin/raw/refs/heads/main/Akagi32.exe
        wget -q https://github.com/yuyudhn/UACME-bin/raw/refs/heads/main/Akagi64.exe
    cd ..

    info "[19] Cloning PKINITtools Repository" && git clone --quiet https://github.com/dirkjanm/PKINITtools.git
    info "[20] Cloning Sysinternals Repository" && git clone --quiet https://github.com/davehardy20/sysinternals.git
    echo "[###] WINDOWS TOOLS DOWNLOAD COMPLETE [###]"
}

# ------------------------------------- MISC TOOLS ----------------------------

misc_tools(){
    echo "[###] DOWNLOADING MISC TOOLS ----------------------------------------------------- ( Total Tools = 8 ) [###]"
    cd "$DIR"

    info "[1] Downloading BloodHound Docker Compose File" && wget -q https://raw.githubusercontent.com/SpecterOps/BloodHound/main/examples/docker-compose/docker-compose.yml -O docker-compose.yml
    info "[2] Cloning DNSCat2 Repository" && git clone --quiet https://github.com/iagox86/dnscat2.git
    info "[3] Cloning pTunnel-ng Repository" && git clone --quiet https://github.com/utoni/ptunnel-ng.git
    info "[4] Cloning SocksOverRDP Repository" && git clone --quiet https://github.com/nccgroup/SocksOverRDP.git
    info "[5] Cloning Dehashed Repository" && git clone --quiet https://github.com/sm00v/Dehashed.git
    info "[6] Downloading GDB-GEF Plugin" && bash -c "$(curl -fsSL https://gef.blah.cat/sh)" > /dev/null
    info "[7] Cloning FuzzDicts Repository" && git clone --quiet https://github.com/TheKingOfDuck/fuzzDicts.git /usr/share/fuzzDicts

    info "[8] Downloading Nmap Binary"
    mkdir -p nmap-binary && cd nmap-binary
        wget -q https://github.com/opsec-infosec/nmap-static-binaries/raw/refs/heads/master/linux/x86_64/nmap && chmod +x ./nmap
        wget -q https://raw.githubusercontent.com/nmap/nmap/refs/heads/master/nmap-protocols
        wget -q https://raw.githubusercontent.com/nmap/nmap/refs/heads/master/nmap-services
    cd ..

    echo "[###] MISC TOOLS DOWNLOAD COMPLETE [###]"
}

# ------------------------------------- HELP / ENTRY --------------------------

show_help() {
    echo "Usage: sudo $0 [linux|windows|misc|all|help]"
    echo
    echo "Options:"
    echo "  linux     Download Linux enumeration tools"
    echo "  windows   Download Windows enumeration tools"
    echo "  misc      Download Miscellaneous Scripts/Tools"
    echo "  all       Download All Tools/Scripts (W/L/M)!!"
    echo "  help      Show this help message and Exit !!!"
}

# Parse command-line argument
if [ $# -eq 0 ]; then
    echo "[!] No arguments provided."
    show_help
    exit 1
fi

case "$1" in
    linux) linux_scripts ;;
    windows) windows_scripts ;;
    misc) misc_tools ;;
    all)
        linux_scripts
        windows_scripts
        misc_tools
        ;;
    help) show_help ;;
    *)
        echo "[!] Invalid argument: $1"
        show_help
        exit 1
        ;;
esac

cd "$DIR"
echo "[###] All selected tools downloaded to: $DIR"
echo "[###] Changing Ownership of $DIR to: $SUDO_USER"
chown "$SUDO_USER:$SUDO_USER" -R "$DIR"
