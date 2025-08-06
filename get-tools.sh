#!/bin/bash
# Author: TheLeopard65

if [ -z "$SUDO_USER" ]; then
    echo "[!] Please run this script with sudo."
    exit 1
fi

clear
echo "[###] STARTING THE PENTESTER'S KALI - LINUX UPDATE SETUP [###]"
figlet "PENTESTER'S KALI - LINUX"
echo "[###] -------------------------------------------------- [###]"

set -euo pipefail
DIR=/home/$SUDO_USER/IMP-TOOLS
mkdir -p "$DIR"
apt-get -qq install -y git zip unzip wget ruby-dev make golang-go golang npm python3

linux_tools() {
    echo "[###] DOWNLOADING LINUX TOOLS ----------------------------------------------------- ( Total Tools = 13 ) [###]"
    cd "$DIR" && mkdir -p linux-scripts && cd linux-scripts

    wget -q --show-progress https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -O linpeas.sh && chmod +x linpeas.sh
    wget -q --show-progress https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -O LinEnum.sh && chmod +x LinEnum.sh
    wget -q --show-progress https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh -O linux-exploit-suggester.sh && chmod +x linux-exploit-suggester.sh
    wget -q --show-progress https://raw.githubusercontent.com/jondonas/linux-exploit-suggester-2/master/linux-exploit-suggester-2.pl -O linux-exploit-suggester-2.pl && chmod +x linux-exploit-suggester-2.pl
    wget -q --show-progress https://github.com/huntergregal/mimipenguin/releases/download/2.0-release/mimipenguin_2.0-release.tar.gz -O mimipenguin-2.0.tar.gz && tar -xzf mimipenguin-2.0.tar.gz && mv mimipenguin_2.0-release mimipenguin-2.0 && rm -f mimipenguin-2.0.tar.gz
    wget -q --show-progress https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 -O pspy64 && chmod +x pspy64
    wget -q --show-progress https://raw.githubusercontent.com/sosdave/KeyTabExtract/refs/heads/master/keytabextract.py -O keytabextract.py && chmod +x keytabextract.py
    wget -q --show-progress https://github.com/jpillora/chisel/releases/download/v1.10.1/chisel_1.10.1_linux_amd64.gz -O chisel-linux-1.10.1.gz && gunzip chisel-linux-1.10.1.gz
    wget -q --show-progress https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64 -O kerbrute && chmod +x ./kerbrute && cp ./kerbrute /usr/bin/kerbrute
    echo "Cloning the SUDO_KILLER Repository" && git clone --quiet https://github.com/TH3xACE/SUDO_KILLER.git
    echo "Cloning the GTFOBins Repository" && git clone --quiet https://github.com/GTFOBins/GTFOBins.github.io.git
    echo "Cloning the Bashark Repository" && git clone --quiet https://github.com/redcode-labs/Bashark.git
    echo "Cloning the Rpivot Repository" && git clone --quiet https://github.com/klsecservices/rpivot.git

    echo "[###] LINUX TOOLS DOWNLOAD COMPLETE [###]"
}

windows_tools() {
    echo "[###] DOWNLOADING WINDOWS TOOLS ----------------------------------------------------- ( Total Tools = 18 ) [###]"
    cd "$DIR" && mkdir -p windows-scripts && cd windows-scripts

    echo "Installing Windows-Binaries on Linux" && apt-get -qq install -y windows-binaries mimikatz rubeus nishang powersploit laudanum
    echo "Cloning the Sysinternals Repository" && git clone --quiet https://github.com/Sysinternals/sysinternals.git
    wget -q --show-progress https://github.com/SpecterOps/SharpHound/releases/download/v2.7.0/SharpHound_v2.7.0_windows_x86.zip -O SharpHound-2.7.0-X86.zip && unzip SharpHound-2.7.0-X86.zip && rm SharpHound-2.7.0-X86.zip SharpHound.exe.config SharpHound.pdb
    wget -q --show-progress https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany.exe -O winPEASany.exe
    wget -q --show-progress https://raw.githubusercontent.com/rasta-mouse/Sherlock/master/Sherlock.ps1 -O Sherlock.ps1
    wget -q --show-progress https://raw.githubusercontent.com/411Hall/JAWS/master/jaws-enum.ps1 -O jaws-enum.ps1
    wget -q --show-progress https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.7/LaZagne.exe -O LaZagne.exe
    wget -q --show-progress https://github.com/klsecservices/rpivot/releases/download/v1.0/client.exe -O rpivot-client.exe
    wget -q --show-progress https://github.com/lukebaggett/dnscat2-powershell/blob/master/dnscat2.ps1 -O dnscat2.ps1
    wget -q --show-progress https://github.com/tevora-threat/SharpView/blob/master/Compiled/SharpView.exe -O SharpView.exe
    wget -q --show-progress https://github.com/dafthack/DomainPasswordSpray/blob/master/DomainPasswordSpray.ps1 -O DomainPasswordSpray.ps1
    wget -q --show-progress https://github.com/leoloobeek/LAPSToolkit/blob/master/LAPSToolkit.ps1 -O LAPSToolkit.ps1
    wget -q --show-progress https://github.com/SnaffCon/Snaffler/releases/download/1.0.212/Snaffler.exe -O Snaffler.exe
    wget -q --show-progress https://github.com/adrecon/ADRecon/blob/master/ADRecon.ps1 -O ADRecon.ps1
    wget -q --show-progress https://github.com/jpillora/chisel/releases/download/v1.10.1/chisel_1.10.1_windows_amd64.gz -O chisel-windows.1.10.1.gz && gunzip chisel-windows.1.10.1.gz && mv chisel-windows.1.10.1 chisel-windows-1.10.1.exe

    mkdir -p socat-windows && cd socat-windows
    wget -q --show-progress https://github.com/3ndG4me/socat/releases/download/v1.7.3.3/socatx64.exe -O socatx64.exe
	wget -q --show-progress https://github.com/3ndG4me/socat/releases/download/v1.7.3.3/socatx86.exe -O socatx86.exe
    cd ..

    mkdir -p ligolo-windows && cd ligolo-windows
    wget -q --show-progress https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.2/ligolo-ng_agent_0.8.2_windows_amd64.zip -O ligolo-Agent-Windows-0.8.2.zip
	unzip ligolo-Agent-Windows-0.8.2.zip && rm ligolo-Agent-Windows-0.8.2.zip && cd ..

	git clone --quiet git clone https://github.com/dirkjanm/PKINITtools.git

    echo "[###] WINDOWS TOOLS DOWNLOAD COMPLETE [###]"
}

misc_tools(){
    echo "[###] DOWNLOADING MISC TOOLS ----------------------------------------------------- ( Total Tools = 5 ) [###]"
    cd "$DIR"

    wget -q --show-progress https://raw.githubusercontent.com/SpecterOps/BloodHound/main/examples/docker-compose/docker-compose.yml -O docker-compose.yml
	echo "Cloning the DNSCat2 Repository" && git clone --quiet https://github.com/iagox86/dnscat2.git
	echo "Cloning the pTunnel Repository" && git clone --quiet https://github.com/utoni/ptunnel-ng.git && cd ptunnel-ng && ./autogen.sh > /dev/null && cd ..
	echo "Cloning the SocksOverRDP Repository" && git clone --quiet https://github.com/nccgroup/SocksOverRDP.git
	echo "Cloning the Dehashed Repository" && git clone --quiet https://github.com/sm00v/Dehashed.git

    echo "[###] MISC TOOLS DOWNLOAD COMPLETE [###]"
}

show_help() {
    echo "Usage: sudo $0 [linux|windows|misc|all|help]"
    echo
    echo "Options:"
    echo "  linux     Download Linux enumeration tools"
    echo "  windows   Download Windows enumeration tools"
    echo "  misc      Download misc tools (BloodHound, socat, etc.)"
    echo "  all       Download all tools"
    echo "  help      Show this help message"
}

# Parse command-line argument
if [ $# -eq 0 ]; then
    echo "[!] No arguments provided."
    show_help
    exit 1
fi

case "$1" in
    linux) linux_tools ;;
    windows) windows_tools ;;
    misc) misc_tools ;;
    all)
        linux_tools
        windows_tools
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
chown "$SUDO_USER:$SUDO_USER" -R "$DIR"
