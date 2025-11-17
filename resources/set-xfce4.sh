#!/bin/bash

if [[ -z "$TARGET_HOME" || "$TARGET_HOME" == "/" ]]; then
    error "TARGET_HOME is invalid — aborting dangerous delete."
    exit 1
fi

# ------------------------------------- USER DIRECTORY SETUP ------------------

info "[###] Setting up a new Desktop Wallpaper ------------------------------------ [ MANUAL ]"

apt-get install -y kali-wallpapers-2023 kali-wallpapers-2024 kali-wallpapers-2025 kali-wallpapers-community > /dev/null
apt-get install -y kali-wallpapers-2019.4 kali-wallpapers-2020.4 kali-wallpapers-2022 > /dev/null

mkdir -p '/usr/share/backgrounds/kali-custom/'
wget -q 'https://wallpapercave.com/wp/wp14448314.jpg' -O /usr/share/backgrounds/kali-custom/firewatch-purple.jpg
wget -q 'https://wallpapercave.com/wp/wp12705841.png' -O /usr/share/backgrounds/kali-custom/black-panther-red.png
wget -q 'https://www.hdwallpapers.in/download/artistic_landscape_view_of_mountains_trees_lights_purple_starry_sky_moon_minimalism_4k_hd_minimalism-HD.jpg' -O /usr/share/backgrounds/kali-custom/watchtower-waterfall.jpg
wget -q 'https://www.kali.org/wallpapers/community/images/community/grey-kali-2025-2-3840x2160.png' -O /usr/share/backgrounds/kali-custom/grey-kali-linux.png
cp /usr/share/backgrounds/kali-16x9/kali-red-sticker.jpg /usr/share/backgrounds/kali-custom/kali-red-sticker.jpg
cp /usr/share/backgrounds/kali-16x9/kali-cubism.jpg /usr/share/backgrounds/kali-custom/kali-cubism.jpg

MONITOR_PATH=$(xfconf-query -c xfce4-desktop -l | grep "monitorVirtual1" | grep "last-image")
IMAGE="/usr/share/backgrounds/kali-setup/kali-red-sticker.jpg"
xfconf-query -c xfce4-desktop -p "$MONITOR_PATH" --type string -s "$IMAGE"

# ------------------------------------- PANEL CUSTOMIZATION -------------------

if [[ "$desk" == "y" ]]; then
    info "[##] Performing XFCE Customizations ------------------------------------- [ MANUAL ]"
    if [[ -d "./.config" || -d "./.local" ]]; then
        rm -rf "${TARGET_HOME}/.config" "${TARGET_HOME}/.local" "${TARGET_HOME}/.cache"
        cp -rpa ./.config "${TARGET_HOME}/"
        cp -rpa ./.local "${TARGET_HOME}/"
    else
        warn "[!!!] Relevent directories not found in current directory, skipping copy."
    fi
fi

# ------------------------------------- USER DIRECTORY SETUP ------------------

if [[ "$udir" == "y" ]]; then
	info "[###] Setting up the User's Home Directory ---------------------------------- [ MANUAL ]"

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
