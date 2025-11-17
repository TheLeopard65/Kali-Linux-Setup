#!/bin/bash

if [[ -z "$TARGET_HOME" || "$TARGET_HOME" == "/" ]]; then
    error "TARGET_HOME is invalid — aborting dangerous delete."
    exit 1
fi

# ------------------------------------- USER DIRECTORY SETUP ------------------

echo -e "${GREEN}[###] ------------------------------------------------------------------------ [###]${NC}"
info "[##] Setting up a new Desktop Wallpaper -------------------------- [ MANUAL ]"

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

MONITOR_PATH=$(xfconf-query -c xfce4-desktop -l | grep "monitorVirtual1" | grep "last-image")
IMAGE="/usr/share/backgrounds/kali-setup/kali-red-sticker.jpg"
xfconf-query -c xfce4-desktop -p "$MONITOR_PATH" --type string -s "$IMAGE"
xfdesktop --reload

# ------------------------------------- PANEL CUSTOMIZATION -------------------

if [[ "$desk" == "y" ]]; then
    info "[##] Performing XFCE Customizations ------------------------------ [ MANUAL ]"
    if [[ -d "./.config" || -d "./.local" ]]; then
        rm -rf "${TARGET_HOME}/.config" "${TARGET_HOME}/.local"
        cp -rpa ./.config "${TARGET_HOME}/"
        cp -rpa ./.local "${TARGET_HOME}/"
    else
        warn "[!!!] Relevent directories not found in current directory, skipping copy."
    fi
fi

# ------------------------------------- USER DIRECTORY SETUP ------------------

if [[ "$udir" == "y" ]]; then
	info "[###] Setting up the User's Home Directory ----------------------- [ MANUAL ]"

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
fi
