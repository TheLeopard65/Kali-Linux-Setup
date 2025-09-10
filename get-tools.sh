#!/bin/bash
# Author: TheLeopard65

if [ -z "$SUDO_USER" ]; then
    echo "[!] Please run this script with sudo."
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
apt-get -qq install -y git zip unzip wget ruby-dev make golang-go golang npm python3

linux_scripts() {
    echo "[###] DOWNLOADING LINUX SCRIPTS ------------------------------------------------------ ( Total Tools = 18 ) [###]"
    cd "$DIR" && mkdir -p linux-scripts && cd linux-scripts

    wget -q --show-progress https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -O LinEnum.sh && chmod +x LinEnum.sh
    wget -q --show-progress https://raw.githubusercontent.com/redcode-labs/Bashark/refs/heads/master/bashark.sh -O bashark.sh && chmod +x bashark.sh
    wget -q --show-progress https://raw.githubusercontent.com/urbanadventurer/username-anarchy/refs/heads/master/username-anarchy && chmod +x username-anarchy
    wget -q --show-progress https://raw.githubusercontent.com/sosdave/KeyTabExtract/refs/heads/master/keytabextract.py -O keytabextract.py && chmod +x keytabextract.py
    wget -q --show-progress https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh -O linux-exploit-suggester.sh && chmod +x linux-exploit-suggester.sh
    wget -q --show-progress https://raw.githubusercontent.com/jondonas/linux-exploit-suggester-2/master/linux-exploit-suggester-2.pl -O linux-exploit-suggester-2.pl && chmod +x linux-exploit-suggester-2.pl
    wget -q --show-progress https://raw.githubusercontent.com/enjoiz/XXEinjector/refs/heads/master/XXEinjector.rb && chmod +x XXEinjector.rb && ln -s $DIR/linux-scripts/XXEinjector.rb /usr/local/bin/XXEinjector
    wget -q --show-progress https://raw.githubusercontent.com/Pwnistry/Windows-Exploit-Suggester-python3/refs/heads/master/windows-exploit-suggester.py -O windows-exploit-suggester.py && chmod +x ./windows-exploit-suggester.py
    wget -q --show-progress https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 -O pspy64 && chmod +x pspy64
    wget -q --show-progress https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -O linpeas.sh && chmod +x linpeas.sh
    wget -q --show-progress https://github.com/jpillora/chisel/releases/download/v1.10.1/chisel_1.10.1_linux_amd64.gz -O chisel-linux.gz && gunzip chisel-linux.gz && chmod +x chisel-linux
    wget -q --show-progress https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64 -O kerbrute && chmod +x ./kerbrute && ln -s $DIR/linux-scripts/kerbrute /usr/local/bin/kerbrute
    wget -q --show-progress https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.2/ligolo-ng_proxy_0.8.2_linux_amd64.tar.gz -O ligolo-proxy.tar.gz && tar -xzf ligolo-proxy.tar.gz && rm -rf LICENSE README.md ligolo-proxy.tar.gz && mv proxy ligolo-proxy
    wget -q --show-progress https://github.com/assetnote/kiterunner/releases/download/v1.0.2/kiterunner_1.0.2_linux_amd64.tar.gz -O kiterunner-1.0.2.tar.gz && tar -xzf kiterunner-1.0.2.tar.gz && ln -s $DIR/linux-scripts/kr /usr/local/bin/kr && rm kiterunner-1.0.2.tar.gz
    wget -q --show-progress https://github.com/huntergregal/mimipenguin/releases/download/2.0-release/mimipenguin_2.0-release.tar.gz -O mimipenguin-2.0.tar.gz && tar -xzf mimipenguin-2.0.tar.gz && mv mimipenguin_2.0-release mimipenguin-2.0 && rm -f mimipenguin-2.0.tar.gz
    echo "Cloning the Linux Kernel Exploits Repository" && git clone --quiet https://github.com/JlSakuya/Linux-Privilege-Escalation-Exploits.git
    echo "Cloning the SUDO_KILLER Repository" && git clone --quiet https://github.com/TH3xACE/SUDO_KILLER.git
    echo "Cloning the Rpivot Repository" && git clone --quiet https://github.com/klsecservices/rpivot.git

    echo "[###] LINUX TOOLS DOWNLOAD COMPLETE [###]"
}

windows_scripts() {
    echo "[###] DOWNLOADING WINDOWS SCRIPTS ---------------------------------------------------- ( Total Tools = 19 ) [###]"
    cd "$DIR" && mkdir -p windows-scripts && cd windows-scripts

    wget -q --show-progress https://raw.githubusercontent.com/411Hall/JAWS/master/jaws-enum.ps1 -O jaws-enum.ps1
    wget -q --show-progress https://raw.githubusercontent.com/rasta-mouse/Sherlock/master/Sherlock.ps1 -O Sherlock.ps1
    wget -q --show-progress https://raw.githubusercontent.com/adrecon/ADRecon/refs/heads/master/ADRecon.ps1 -O ADRecon.ps1
    wget -q --show-progress https://raw.githubusercontent.com/leoloobeek/LAPSToolkit/refs/heads/master/LAPSToolkit.ps1 -O LAPSToolkit.ps1
    wget -q --show-progress https://raw.githubusercontent.com/lukebaggett/dnscat2-powershell/refs/heads/master/dnscat2.ps1 -O dnscat2.ps1
    wget -q --show-progress https://raw.githubusercontent.com/dafthack/DomainPasswordSpray/refs/heads/master/DomainPasswordSpray.ps1 -O DomainPasswordSpray.ps1
    wget -q --show-progress https://raw.githubusercontent.com/danielbohannon/Invoke-DOSfuscation/refs/heads/master/Invoke-DOSfuscation.psd1 -O Invoke-DOSfuscation.psd1
    wget -q --show-progress https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.7/LaZagne.exe -O LaZagne.exe
    wget -q --show-progress https://github.com/SnaffCon/Snaffler/releases/download/1.0.212/Snaffler.exe -O Snaffler.exe
    wget -q --show-progress https://github.com/klsecservices/rpivot/releases/download/v1.0/client.exe -O rpivot-client.exe
    wget -q --show-progress https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany.exe -O winPEASany.exe
    wget -q --show-progress https://github.com/tevora-threat/SharpView/raw/refs/heads/master/Compiled/SharpView.exe -O SharpView.exe
    wget -q --show-progress https://github.com/jpillora/chisel/releases/download/v1.10.1/chisel_1.10.1_windows_amd64.gz -O chisel-windows.1.10.1.gz && gunzip chisel-windows.1.10.1.gz && mv chisel-windows.1.10.1 chisel-windows-1.10.1.exe
    wget -q --show-progress https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.2/ligolo-ng_agent_0.8.2_windows_amd64.zip -O ligolo-Agent.zip && unzip -qq ligolo-Agent.zip && rm -f ligolo-Agent.zip LICENSE README.md && mv agent.exe ligolo-agent.exe
    wget -q --show-progress https://github.com/Kevin-Robertson/Inveigh/releases/download/v2.0.11/Inveigh-net8.0-win-x64-trimmed-single-v2.0.11.zip -O Inveigh-Net8-Win-2.0.11.zip && unzip -qq Inveigh-Net8-Win-2.0.11.zip && rm -f Inveigh.pdb Inveigh-Net8-Win-2.0.11.zip

    mkdir -p socat-windows && cd socat-windows
    wget -q --show-progress https://github.com/3ndG4me/socat/releases/download/v1.7.3.3/socatx64.exe -O socatx64.exe
    wget -q --show-progress https://github.com/3ndG4me/socat/releases/download/v1.7.3.3/socatx86.exe -O socatx86.exe
    cd ..

    mkdir -p UACME-Akagi && cd UACME-Akagi
    wget -q --show-progress https://github.com/yuyudhn/UACME-bin/raw/refs/heads/main/Akagi32.exe
    wget -q --show-progress https://github.com/yuyudhn/UACME-bin/raw/refs/heads/main/Akagi64.exe
    cd ..

    echo "Cloning the PKINITtools Repository" && git clone --quiet https://github.com/dirkjanm/PKINITtools.git
    echo "Cloning the Sysinternals Repository" && git clone --quiet https://github.com/Sysinternals/sysinternals.git

    echo "[###] WINDOWS TOOLS DOWNLOAD COMPLETE [###]"
}

misc_tools(){
    echo "[###] DOWNLOADING MISC TOOLS ----------------------------------------------------- ( Total Tools = 5 ) [###]"
    cd "$DIR"

    wget -q --show-progress https://raw.githubusercontent.com/SpecterOps/BloodHound/main/examples/docker-compose/docker-compose.yml -O docker-compose.yml
    echo "Cloning the DNSCat2 Repository" && git clone --quiet https://github.com/iagox86/dnscat2.git
    echo "Cloning the pTunnel Repository" && git clone --quiet https://github.com/utoni/ptunnel-ng.git
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
