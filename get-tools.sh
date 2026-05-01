#!/bin/bash
#Author: TheLeopard65

set -euo pipefail

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
success() { echo -e "${GREEN}[ OK ]${NC} $1"; }

if [[ "$(id -u)" -ne 0 ]]; then
    error "Please run this script using ROOT or SUDO. (For example: 'sudo $0')!"
    exit 1
fi

apt-get -qq install -y figlet git zip gzip unzip wget ruby-dev make python3

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
figlet "PENTESTER'S KALI - LINUX"
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"

TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME="$(eval echo "~$TARGET_USER")"
DIR="$TARGET_HOME/IMP-TOOLS"
cleanup=""

rerun_cleanup() {
    echo "[###] REMOVING PRE-EXISTING SCRIPTS ----------------------------------------------------------------------------------- [###]"
    rm -rf "$DIR" /usr/share/fuzzDicts

    for bin in kerbrute kr XXEinjector targetedKerberoast.py ligolo-proxy ligolo-agent; do
        rm -f "/usr/local/bin/$bin" 2>/dev/null || true
    done
}

linux_scripts() (
    echo "[###] DOWNLOADING LINUX SCRIPTS ------------------------------------------------------------------ ( Total Tools = 19 ) [###]"
    mkdir -p "$DIR/linux-scripts" && cd "$DIR/linux-scripts"

    info "[1] Downloading LinEnum Script" && wget -q https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -O LinEnum.sh && chmod +x LinEnum.sh
    info "[2] Downloading bashark Script" && wget -q https://raw.githubusercontent.com/redcode-labs/Bashark/refs/heads/master/bashark.sh -O bashark.sh && chmod +x bashark.sh
    info "[3] Downloading username-anarchy tool" && wget -q https://raw.githubusercontent.com/urbanadventurer/username-anarchy/refs/heads/master/username-anarchy && chmod +x username-anarchy
    info "[4] Downloading keytabextract.py tool" && wget -q https://raw.githubusercontent.com/sosdave/KeyTabExtract/refs/heads/master/keytabextract.py -O keytabextract.py && chmod +x keytabextract.py
    info "[5] Downloading Linux-exploit-suggester" && wget -q https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh -O linux-exploit-suggester.sh && chmod +x linux-exploit-suggester.sh
    info "[6] Downloading Linux-exploit-suggester-2" && wget -q https://raw.githubusercontent.com/jondonas/linux-exploit-suggester-2/master/linux-exploit-suggester-2.pl -O linux-exploit-suggester-2.pl && chmod +x linux-exploit-suggester-2.pl
    info "[7] Downloading XXEinjector" && wget -q https://raw.githubusercontent.com/enjoiz/XXEinjector/refs/heads/master/XXEinjector.rb -O XXEinjector.rb && chmod +x XXEinjector.rb && ln -sf "$DIR/linux-scripts/XXEinjector.rb" /usr/local/bin/XXEinjector
    info "[8] Downloading Windows Exploit Suggester" && wget -q https://raw.githubusercontent.com/Pwnistry/Windows-Exploit-Suggester-python3/refs/heads/master/windows-exploit-suggester.py -O windows-exploit-suggester.py && chmod +x windows-exploit-suggester.py
    info "[9] Downloading pspy64" && wget -q https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 -O pspy64 && chmod +x pspy64
    info "[10] Downloading linpeas" && wget -q https://github.com/peass-ng/PEASS-ng/releases/download/20260412-090b08ae/linpeas.sh -O linpeas.sh && chmod +x linpeas.sh
    info "[11] Downloading chisel-linux" && wget -q https://github.com/jpillora/chisel/releases/download/v1.11.5/chisel_1.11.5_linux_amd64.gz -O chisel-linux.gz && gunzip chisel-linux.gz && chmod +x chisel-linux
    info "[12] Downloading kerbrute" && wget -q https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64 -O kerbrute && chmod +x kerbrute && ln -sf "$DIR/linux-scripts/kerbrute" /usr/local/bin/kerbrute
    info "[13] Downloading winrmexec.py" && wget -q https://raw.githubusercontent.com/ozelis/winrmexec/refs/heads/main/winrmexec.py -O winrmexec.py

    info "[14] Downloading ligolo-NG Tools"
	mkdir -p ligolo-tools && cd ligolo-tools
	    wget -q https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.3/ligolo-ng_proxy_0.8.3_linux_amd64.tar.gz -O ligolo-proxy.tar.gz && tar -xzf ligolo-proxy.tar.gz && rm -rf LICENSE README.md ligolo-proxy.tar.gz && mv proxy ligolo-proxy
	    wget -q https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.3/ligolo-ng_agent_0.8.3_linux_amd64.tar.gz -O ligolo-agent.tar.gz && tar -xzf ligolo-agent.tar.gz  && rm -rf LICENSE README.md ligolo-agent.tar.gz && mv agent ligolo-agent
	cd ..

	info "[15] Downloading kiterunner" && wget -q https://github.com/assetnote/kiterunner/releases/download/v1.0.2/kiterunner_1.0.2_linux_amd64.tar.gz -O kiterunner-1.0.2.tar.gz && tar -xzf kiterunner-1.0.2.tar.gz && ln -sf "$DIR/linux-scripts/kr" /usr/local/bin/kr && rm kiterunner-1.0.2.tar.gz
    info "[16] Downloading mimipenguin" && wget -q https://github.com/huntergregal/mimipenguin/releases/download/2.0-release/mimipenguin_2.0-release.tar.gz -O mimipenguin-2.0.tar.gz && tar -xzf mimipenguin-2.0.tar.gz && mv mimipenguin_2.0-release mimipenguin-2.0 && rm -f mimipenguin-2.0.tar.gz
    info "[17] Cloning Linux Kernel Exploits Repository" && git clone --quiet https://github.com/JlSakuya/Linux-Privilege-Escalation-Exploits.git
    info "[18] Cloning SUDO_KILLER Repository" && git clone --quiet https://github.com/TH3xACE/SUDO_KILLER.git
    info "[19] Cloning Rpivot Repository" && git clone --quiet https://github.com/klsecservices/rpivot.git
)

windows_scripts() (
    echo "[###] DOWNLOADING WINDOWS SCRIPTS ---------------------------------------------------------------- ( Total Tools = 21 ) [###]"
    mkdir -p "$DIR/windows-scripts" && cd "$DIR/windows-scripts"

    info "[1] Downloading JAWS Script" && wget -q https://raw.githubusercontent.com/411Hall/JAWS/master/jaws-enum.ps1 -O jaws-enum.ps1
    info "[2] Downloading Sherlock" && wget -q https://raw.githubusercontent.com/rasta-mouse/Sherlock/master/Sherlock.ps1 -O Sherlock.ps1
    info "[3] Downloading ADRecon" && wget -q https://raw.githubusercontent.com/adrecon/ADRecon/refs/heads/master/ADRecon.ps1 -O ADRecon.ps1
    info "[4] Downloading LAPSToolkit" && wget -q https://raw.githubusercontent.com/leoloobeek/LAPSToolkit/refs/heads/master/LAPSToolkit.ps1 -O LAPSToolkit.ps1
    info "[5] Downloading dnscat2.ps1" && wget -q https://raw.githubusercontent.com/lukebaggett/dnscat2-powershell/refs/heads/master/dnscat2.ps1 -O dnscat2.ps1
    info "[6] Downloading DomainPasswordSpray" && wget -q https://raw.githubusercontent.com/dafthack/DomainPasswordSpray/refs/heads/master/DomainPasswordSpray.ps1 -O DomainPasswordSpray.ps1
    info "[7] Downloading Invoke-DOSfuscation" && wget -q https://raw.githubusercontent.com/danielbohannon/Invoke-DOSfuscation/refs/heads/master/Invoke-DOSfuscation.psd1 -O Invoke-DOSfuscation.psd1
    info "[8] Downloading TargetedKerberoast.py" && wget -q https://raw.githubusercontent.com/ShutdownRepo/targetedKerberoast/refs/heads/main/targetedKerberoast.py -O targetedKerberoast.py && ln -sf "$DIR/windows-scripts/targetedKerberoast.py" /usr/local/bin/targetedKerberoast.py
    info "[9] Downloading LaZagne.exe" && wget -q https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.7/LaZagne.exe -O LaZagne.exe
    info "[10] Downloading Snaffler.exe" && wget -q https://github.com/SnaffCon/Snaffler/releases/download/1.0.244/Snaffler.exe -O Snaffler.exe
    info "[11] Downloading Rpivot Client" && wget -q https://github.com/klsecservices/rpivot/releases/download/v1.0/client.exe -O rpivot-client.exe
    info "[12] Downloading winPEASany" && wget -q https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany.exe -O winPEASany.exe
    info "[13] Downloading SharpView.exe" && wget -q https://github.com/tevora-threat/SharpView/raw/refs/heads/master/Compiled/SharpView.exe -O SharpView.exe
    info "[14] Downloading chisel-windows" && wget -q https://github.com/jpillora/chisel/releases/download/v1.11.5/chisel_1.11.5_windows_amd64.gz -O chisel-windows.1.11.5.gz && gunzip chisel-windows.1.11.5.gz && mv chisel-windows.1.11.5 chisel-windows-1.11.5.exe
    info "[15] Downloading ligolo-agent" && wget -q https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.3/ligolo-ng_agent_0.8.3_windows_amd64.zip -O ligolo-Agent.zip && unzip -qq ligolo-Agent.zip && rm -f ligolo-Agent.zip LICENSE README.md && mv agent.exe ligolo-agent.exe
    info "[16] Downloading RunasCs-tool" && wget -q https://github.com/antonioCoco/RunasCs/releases/download/v1.5/RunasCs.zip -O RunasCs.zip && unzip RunasCs.zip -d Runas-Binaries && rm RunasCs.zip
    info "[17] Downloading Rubeus.exe" && wget -q https://github.com/Flangvik/SharpCollection/raw/refs/heads/master/NetFramework_4.0_Any/Rubeus.exe -O Rubeus.exe
    info "[18] Downloading PowerView.ps1" && wget -q https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/refs/heads/master/Recon/PowerView.ps1 -O PowerView.ps1

    info "[19] Downloading Inveigh Tools"
    mkdir -p inveigh-tools && cd inveigh-tools
        wget -q https://github.com/Kevin-Robertson/Inveigh/releases/download/v2.0.12/Inveigh-net10.0-v2.0.12.zip -O Inveigh-net10.0-v2.0.12.zip
        unzip -qq Inveigh-net10.0-v2.0.12.zip && rm -f Inveigh.pdb Inveigh-net10.0-v2.0.12.zip
        wget -q https://raw.githubusercontent.com/Kevin-Robertson/Inveigh/refs/heads/master/Inveigh.ps1
    cd ..

    info "[20] Downloading socat windows"
    mkdir -p socat-windows && cd socat-windows
        wget -q https://github.com/3ndG4me/socat/releases/download/v1.7.3.3/socatx64.exe -O socatx64.exe
        wget -q https://github.com/3ndG4me/socat/releases/download/v1.7.3.3/socatx86.exe -O socatx86.exe
    cd ..

    info "[21] Downloading UACME - Akagi"
    mkdir -p UACME-Akagi && cd UACME-Akagi
        wget -q https://github.com/yuyudhn/UACME-bin/raw/refs/heads/main/Akagi32.exe
        wget -q https://github.com/yuyudhn/UACME-bin/raw/refs/heads/main/Akagi64.exe
    cd ..

    info "[22] Cloning PKINITtools Repository" && git clone --quiet https://github.com/dirkjanm/PKINITtools.git
    info "[23] Cloning Sysinternals Repository" && git clone --quiet https://github.com/davehardy20/sysinternals.git
)

misc_tools() (
    echo "[###] DOWNLOADING MISC TOOLS ---------------------------------------------------------------------- ( Total Tools = 8 ) [###]"
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
)

prompt_yes_no() {
    read -p "[#] $1 (Y/N) [default: N]: " reply
    reply=${reply:-N}
    echo "${reply,,}"
}

lint=$(prompt_yes_no "1. Download Linux Tools/Scripts? ----------")
wint=$(prompt_yes_no "2. Downlaod Windows Binaries/Tools? -------")
mist=$(prompt_yes_no "3. Download Misc Tools & Scripts? ---------")

if [[ -d "$DIR" ]]; then
    cleanup=$(prompt_yes_no "Directory exists. Delete and reinstall from scratch?")
    if [[ "$cleanup" == "y" ]]; then
        rerun_cleanup
    fi
fi

mkdir -p "$DIR"

if [[ "$lint" == "y" ]]; then linux_scripts; fi
if [[ "$wint" == "y" ]]; then windows_scripts; fi
if [[ "$mist" == "y" ]]; then misc_tools; fi

cd "$DIR"
echo "[###] All selected tools downloaded to: $DIR"
echo "[###] Changing Ownership of $DIR to: $TARGET_USER"
chown "$TARGET_USER:$TARGET_USER" -R "$DIR"

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
echo -e "${GREEN}[###] Kali-Linux Pentester's Toolbox Setup is finally complete!${NC}"
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
