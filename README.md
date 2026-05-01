# Kali-Linux-Setup

> Automated setup scripts for a complete penetration testing environment on Kali Linux

This repository contains a comprehensive collection of scripts to automate the setup, customization, tool deployment, and maintenance of a **Kali Linux** system tailored for red teaming, CTF competitions, and security assessments.

---

## 📁 Repository Structure

```
Kali-Linux-Setup/
├── install.sh           # Main environment setup (tools, libraries, services)
├── get-tools.sh         # Download additional Linux/Windows red team tools
├── setup-home.sh        # Configure user home directories, dotfiles, and XFCE
├── pwn-setup.sh         # Dedicated binary exploitation / pwn lab environment
├── update.sh            # System and tool database updater
├── croncreator.sh       # Install monthly cron job for automatic updates
├── resources/           # Configuration files (bashrc, zshrc, nanorc, wallpapers)
│   ├── bashrc
│   ├── zshrc
│   ├── nanorc
│   ├── nano-syntax.sh
│   ├── .config/         # XFCE configuration profiles
│   └── .local/          # User-local application data
├── LICENSE.md           # MIT License
└── README.md            # This file
```

---

## Scripts Overview

### 1. `install.sh` – Full Environment Setup

This is the **primary setup script**. It installs over 200 tools, Python libraries, and optional components.

**Features:**
- Full system update & upgrade
- Bulk installation of penetration testing tools (recon, web, AD, wireless, binary, pivoting, etc.)
- Python3 libraries for web, networking, AI/ML, and exploitation
- Optional installation of:
  - Pipx tools (e.g., `pwntools`, `impacket`, `bloodhound`)
  - Python2 + pip2 (legacy support)
  - Older Python3 versions via `pyenv` (3.8, 3.10, 3.11)
  - Snapd and snap packages
  - Global Git configuration
  - Wine32 (i386 architecture support)
- Docker group assignment for the target user
- Extracts `rockyou.txt` wordlist
- Updates `searchsploit`, `nmap` scripts, and the `locate` database
- Disables automatic time sync (to avoid issues in virtual environments)

**Usage:**
```bash
sudo ./install.sh
```

You will be prompted to select optional components.

---

### 2. `get-tools.sh` – Additional Red Team / CTF Tools

Downloads ready-to-use scripts and binaries for Linux and Windows post‑exploitation into `~/IMP-TOOLS/`.

**Tool categories:**
- **Linux**: `LinEnum`, `pspy64`, `linpeas`, `linux-exploit-suggester`, `SUDO_KILLER`, `rpivot`, `chisel`, `kerbrute`, `ligolo-ng`, `kiterunner`, `mimipenguin`, and more.
- **Windows**: `winPEAS`, `Sherlock`, `ADRecon`, `Rubeus`, `PowerView`, `LaZagne`, `Inveigh`, `SharpView`, `RunasCs`, `UACME`, and many others.
- **Misc**: BloodHound docker compose, DNSCat2, ptunnel-ng, GDB‑GEF, FuzzDicts, and a static Nmap binary.

**Interactive prompts:**
- Run Linux tools? (Y/N) – default Y
- Run Windows tools? (Y/N) – default Y
- Run Misc tools? (Y/N) – default N

**Usage:**
```bash
sudo ./get-tools.sh
```

> All downloaded files are owned by your non‑root user (the `SUDO_USER`).

---

### 3. `setup-home.sh` – Home Directory & Desktop Customization

Configures your user environment for a polished and efficient workflow.

**Interactive options:**
1. Modify `nanorc` (syntax highlighting, better UI)
2. Modify `.zshrc` (Zsh prompt and aliases)
3. Modify `.bashrc` (Bash prompt and aliases)
4. Customize XFCE4 settings (theming, panels, shortcuts)
5. Set up structured folders in `$HOME` (recon, loot, exploits, CTF, OpenVPN, etc.)
6. Generate an SSH key pair (ed25519)

**Additionally (always runs):**
- Installs Kali wallpapers from 2019‑2025
- Downloads custom wallpapers to `/usr/share/backgrounds/kali-custom/`

**Usage:**
```bash
sudo ./setup-home.sh
```

> After running, you may need to restart your terminal or run `source ~/.bashrc` / `source ~/.zshrc`.

---

### 4. `pwn-setup.sh` – Binary Exploitation / Pwn Lab

Creates a dedicated Python virtual environment and installs essential pwn tools.

**What it does:**
- Updates system packages
- Installs: `python3-venv`, `pipx`, `gdb`, `radare2`, `pwncat`, `strace`, `ltrace`, `binutils`, `socat`, `impacket-scripts`, `ruby`, `ruby-dev`, `rubygems`
- Creates `~/PWN-VENV` with `pwntools`, `pwn-flashlib`, `ROPGadget`
- Installs `one_gadget` Ruby gem
- Installs `pwntools`, `ROPGadget`, `impacket` via `pipx`

**Usage:**
```bash
sudo ./pwn-setup.sh
```

After completion, activate the environment with:
```bash
source ~/PWN-VENV/bin/activate
```

---

### 5. `update.sh` – System & Database Updater

Performs a clean, non‑interactive update of the entire system.

**Actions:**
- `apt-get update`, `upgrade -y`, `full-upgrade -y`, `autoremove -y`
- `searchsploit -u`
- `nmap --script-updatedb`
- `updatedb`

**Usage:**
```bash
sudo ./update.sh
```

> All output is kept quiet (`-qq`). Errors are still shown.

---

### 6. `croncreator.sh` – Monthly Automatic Updates

Sets up a cron job that runs `update.sh` once a month.

**Schedule:** `0 0 1 * *` (1st day of every month at midnight)
**Log:** `/var/log/update.log`

**Usage:**
```bash
sudo ./croncreator.sh
```

> The script copies `update.sh` to `/root/.update.sh` to ensure it always runs as root.

---

## Resources Directory

| File / Folder         | Purpose                                                                 |
|-----------------------|-------------------------------------------------------------------------|
| `bashrc`              | Custom Bash prompt, aliases, and environment variables                  |
| `zshrc`               | Zsh configuration with syntax highlighting, plugins, and prompt         |
| `nanorc`              | Improved Nano settings with syntax highlighting for many languages      |
| `nano-syntax.sh`      | Script to install missing Nano syntax definitions                       |
| `.config/`            | XFCE panel, desktop, and theme presets                                  |
| `.local/`             | User‑local applications and data (e.g., `Thunar` custom actions)        |

These files are applied automatically when you select the corresponding options in `setup-home.sh`.

---

## Requirements

- **Operating System:** Kali Linux (bare metal, VM, or physical)
- **Privileges:** All scripts must be run as **root** (using `sudo`)
- **Internet connection:** Required for downloading packages and tools

---

## Disclaimer

These scripts are provided **as‑is** without any warranty. They are intended for authorized security testing and educational purposes only. The author is not responsible for any misuse or damage caused by these scripts. Always review the code before running it on production or sensitive systems.

---

## License

This project is licensed under the MIT License – see the [LICENSE.md](LICENSE.md) file for details.

---

## Author

**Yasir Mehmood (TheLeopard65)**  
GitHub: [@TheLeopard65](https://github.com/TheLeopard65)

---

*Happy hacking – stay legal and ethical.*

---
