#!/bin/bash

set -e

DEST_DIR=~/enum-scripts
mkdir -p "$DEST_DIR"

download_linux_tools() {
    echo "[*] Downloading Linux Enumeration Tools to $DEST_DIR..."
    cd "$DEST_DIR"

    # linPEAS
    wget -q --show-progress https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -O linpeas.sh
    chmod +x linpeas.sh

    # LinEnum
    wget -q --show-progress https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -O LinEnum.sh
    chmod +x LinEnum.sh

    # Linux Exploit Suggester 1
    wget -q --show-progress https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh -O linux-exploit-suggester.sh
    chmod +x linux-exploit-suggester.sh

    # Linux Exploit Suggester 2
    wget -q --show-progress https://raw.githubusercontent.com/jondonas/linux-exploit-suggester-2/master/linux-exploit-suggester-2.pl -O linux-exploit-suggester-2.pl
    chmod +x linux-exploit-suggester-2.pl

    # Bashark
    git clone --quiet https://github.com/redcode-labs/Bashark.git

    # unix-privesc-check
    wget -q --show-progress https://raw.githubusercontent.com/pentestmonkey/unix-privesc-check/master/unix-privesc-check -O unix-privesc-check
    chmod +x unix-privesc-check

    # SUDO_KILLER
    git clone --quiet https://github.com/TH3xACE/SUDO_KILLER.git

    # GTFOBins (offline reference)
    git clone --quiet https://github.com/GTFOBins/GTFOBins.github.io.git

    # pspy
    wget -q --show-progress https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 -O pspy64
    chmod +x pspy64

    echo "[+] Linux tools downloaded."
}

download_windows_tools() {
    echo "[*] Downloading Windows Enumeration Tools to $DEST_DIR..."
    cd "$DEST_DIR"

    # winPEAS
    wget -q --show-progress https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany.exe -O winPEASany.exe

    # PowerUp
    wget -q --show-progress https://raw.githubusercontent.com/PowerShellEmpire/PowerTools/master/PowerUp/PowerUp.ps1 -O PowerUp.ps1

    # PowerView
    wget -q --show-progress https://raw.githubusercontent.com/PowerShellEmpire/PowerTools/master/PowerView/PowerView.ps1 -O PowerView.ps1

    # Sherlock
    wget -q --show-progress https://raw.githubusercontent.com/rasta-mouse/Sherlock/master/Sherlock.ps1 -O Sherlock.ps1

    # Seatbelt
    git clone --quiet https://github.com/GhostPack/Seatbelt.git

    # Watson
    git clone --quiet https://github.com/rasta-mouse/Watson.git

    # JAWS
    wget -q --show-progress https://raw.githubusercontent.com/411Hall/JAWS/master/jaws-enum.ps1 -O jaws-enum.ps1

    # WinEnum
    wget -q --show-progress https://raw.githubusercontent.com/S3cur3Th1sSh1t/WinEnum/master/WinEnum.bat -O WinEnum.bat

    # Nishang
    git clone --quiet https://github.com/samratashok/nishang.git

    echo "[+] Windows tools downloaded."
}

echo "Select what you want to download:"
echo "1) Linux tools"
echo "2) Windows tools"
echo "3) Both"
echo "4) None (exit)"
read -rp "Enter your choice [1-4]: " choice

case "$choice" in
    1)
        download_linux_tools
        ;;
    2)
        download_windows_tools
        ;;
    3)
        download_linux_tools
        download_windows_tools
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

echo "[✓] All selected tools downloaded to: $DEST_DIR"
