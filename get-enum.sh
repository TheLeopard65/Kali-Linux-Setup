#!/bin/bash
# Author: TheLeopard65

if [ -z "$SUDO_USER" ]; then
    echo "[!] Please run this script with sudo."
    exit 1
fi

set -euo pipefail
DIR=/home/$SUDO_USER/enum-scripts
mkdir -p "$DIR"
apt-get install -y git zip unzip wget

linux_tools() {
    echo "[###] DOWNLOADING LINUX TOOLS [###]"
    cd "$DIR" && mkdir -p linux && cd linux
    wget -q --show-progress https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -O linpeas.sh && chmod +x linpeas.sh
    wget -q --show-progress https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -O LinEnum.sh && chmod +x LinEnum.sh
    wget -q --show-progress https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh -O linux-exploit-suggester.sh && chmod +x linux-exploit-suggester.sh
    wget -q --show-progress https://raw.githubusercontent.com/jondonas/linux-exploit-suggester-2/master/linux-exploit-suggester-2.pl -O linux-exploit-suggester-2.pl && chmod +x linux-exploit-suggester-2.pl
    wget -q --show-progress https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 -O pspy64 && chmod +x pspy64
    git clone --quiet https://github.com/redcode-labs/Bashark.git
    git clone --quiet https://github.com/TH3xACE/SUDO_KILLER.git
    git clone --quiet https://github.com/GTFOBins/GTFOBins.github.io.git
    echo "[###] LINUX TOOLS DOWNLOAD COMPLETE [###]"
}

windows_tools() {
    echo "[###] DOWNLOADING WINDOWS TOOLS [###]"
    cd "$DIR" && mkdir -p windows && cd windows
    wget -q --show-progress https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany.exe -O winPEASany.exe
    wget -q --show-progress https://raw.githubusercontent.com/rasta-mouse/Sherlock/master/Sherlock.ps1 -O Sherlock.ps1
    wget -q --show-progress https://raw.githubusercontent.com/411Hall/JAWS/master/jaws-enum.ps1 -O jaws-enum.ps1
    git clone --quiet https://github.com/Sysinternals/sysinternals.git
    git clone --quiet https://github.com/samratashok/nishang.git
    echo "[###] WINDOWS TOOLS DOWNLOAD COMPLETE [###]"
}

misc_tools(){
    echo "[###] DOWNLOADING MISC TOOLS [###]"
    cd "$DIR"

    wget -q --show-progress https://raw.githubusercontent.com/SpecterOps/BloodHound/main/examples/docker-compose/docker-compose.yml -O docker-compose.yml

    mkdir -p sharphound && cd sharphound
    wget -q --show-progress https://github.com/SpecterOps/SharpHound/releases/download/v2.7.0/SharpHound_v2.7.0_windows_x86.zip -O SharpHound_v2.7.0_windows_x86.zip
    unzip SharpHound_v2.7.0_windows_x86.zip && rm SharpHound_v2.7.0_windows_x86.zip
    cd ..

    mkdir -p socat-windows && cd socat-windows
    wget -q --show-progress https://github.com/3ndG4me/socat/releases/download/v1.7.3.3/socatx64.exe -O socatx64.exe
    wget -q --show-progress https://github.com/3ndG4me/socat/releases/download/v1.7.3.3/socatx86.exe -O socatx86.exe
    cd ..

    mkdir -p ligolo-windows && cd ligolo-windows
    wget -q --show-progress https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.2/ligolo-ng_agent_0.8.2_windows_amd64.zip
    unzip ligolo-ng_agent_0.8.2_windows_amd64.zip && rm ligolo-ng_agent_0.8.2_windows_amd64.zip
    cd ..

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
