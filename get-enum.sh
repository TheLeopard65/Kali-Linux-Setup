#!/bin/bash
#Author: TheLeopard65

if [ -z "$SUDO_USER" ]; then
    echo "[!] Please run this script with sudo."
    exit 1
fi

set -euo pipefail
DIR=/home/$SUDO_USER/enum-scripts
mkdir -p "$DIR"

linux_tools() {
    echo "[###] DOWNLOADING LINUX TOOLS [###]"
    cd "$DIR" && mkdir -p linux && cd linux

    # linPEAS
    wget -q --show-progress https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -O linpeas.sh && chmod +x linpeas.sh

    # LinEnum
    wget -q --show-progress https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -O LinEnum.sh && chmod +x LinEnum.sh

    # Linux Exploit Suggester 1
    wget -q --show-progress https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh -O linux-exploit-suggester.sh && chmod +x linux-exploit-suggester.sh

    # Linux Exploit Suggester 2
    wget -q --show-progress https://raw.githubusercontent.com/jondonas/linux-exploit-suggester-2/master/linux-exploit-suggester-2.pl -O linux-exploit-suggester-2.pl && chmod +x linux-exploit-suggester-2.pl

    # Bashark
    git clone --quiet https://github.com/redcode-labs/Bashark.git

    # SUDO_KILLER
    git clone --quiet https://github.com/TH3xACE/SUDO_KILLER.git

    # GTFOBins (offline reference)
    git clone --quiet https://github.com/GTFOBins/GTFOBins.github.io.git

    # pspy
    wget -q --show-progress https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 -O pspy64 && chmod +x pspy64

    echo "[###] LINUX TOOLS DOWNLOAD COMPLETE [###]"
}

windows_tools() {
    echo "[###] DOWNLOADING WINDOWS TOOLS [###]"
    cd "$DIR" && mkdir -p windows && cd windows

    # winPEAS
    wget -q --show-progress https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany.exe -O winPEASany.exe

	# PowerSploit
	git clone --quiet https://github.com/PowerShellMafia/PowerSploit.git

    # PowerUp
    cp PowerSploit/Prives/PowerUp.ps1 ./PowerUp.ps1 && chmod 644 ./PowerUp.ps1

    # PowerView
    cp PowerSploit/Recon/PowerView.ps1 ./PowerView.ps1 && chmod 644 ./PowerView.ps1

    # Sherlock
    wget -q --show-progress https://raw.githubusercontent.com/rasta-mouse/Sherlock/master/Sherlock.ps1 -O Sherlock.ps1

    # JAWS
    wget -q --show-progress https://raw.githubusercontent.com/411Hall/JAWS/master/jaws-enum.ps1 -O jaws-enum.ps1

	# Sysinternals
	git clone --quiet https://github.com/Sysinternals/sysinternals.git

    # Nishang
    git clone --quiet https://github.com/samratashok/nishang.git

    echo "[###] WINDOWS TOOLS DOWNLOAD COMPLETE [###]"
}

echo "[###] Enum Scripts Downloader [###]"
echo "Select what you want to download:"
echo "1) Linux tools"
echo "2) Windows tools"
echo "3) Both"
echo "4) None (exit)"
read -rp "Enter your choice [1-4]: " choice

case "$choice" in
    1) linux_tools ;;
    2) windows_tools ;;
    3)
       linux_tools
       windows_tools
        ;;
    4)
        echo "[-] Exiting. Nothing was downloaded."
        exit 0
        ;;
    *)
        echo "[!] Invalid option. Exiting."
        exit 1
        ;;
esac

cd "$DIR"
echo "[###] All selected tools downloaded to: $DIR"
chown "$SUDO_USER":"$SUDO_USER" -R "$DIR"
