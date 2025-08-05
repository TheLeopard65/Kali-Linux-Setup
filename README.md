# Kali-Linux-Setup
==================

This repository contains a comprehensive set of scripts to automate the setup, update, customization, and maintenance of a **Kali Linux** environment, tailored for penetration testing and red teaming purposes.

---

## 📜 Contents

- [`install.sh`](#installsh) – Complete environment setup
- [`update.sh`](#updatesh) – System and tool updates
- [`croncreator.sh`](#croncreatorsh) – Automate monthly updates
- [`get-tools.sh`](#get-toolssh) – Download additional red team/CTF tools
- [`bashrc`](#bashrc) – Custom Bash configuration
- [`nanorc`](#nanorc) – Improved Nano syntax and usability
- [`LICENSE.md`](LICENSE.md) – License file

> **This repository was previously named WSL2-Setup and focused on Kali Linux within WSL2. It is now focused on Kali Linux as a standalone environment.**

---

## `install.sh`

This is the **main setup script**, intended to bootstrap a full-featured Kali Linux environment for penetration testing and security research.

### Key Features:

- **System Update & Upgrade**
- **Installs Over 100 Security Tools** across categories:
  - Reconnaissance
  - Web & Network Scanners
  - Exploitation
  - Privilege Escalation
  - Active Directory Attacks
  - Wireless Hacking
  - Binary & APK Analysis
  - Tunneling & Pivoting
- **Python 3 Libraries** (optionally installs Python 2 & pip2)
- **Pipx Tools** (e.g., pwntools, ropgadget, ipython, impacket)
- **Optional Customizations:**
  - Global Git configuration
  - Enhanced `.bashrc`
  - Updated `nanorc` with syntax highlighting
- **Docker & Wine32** support for running various environments
- **Updates security databases**: `searchsploit`, `nmap`, `greenbone`, etc.

### Usage:

```bash
sudo chmod +x install.sh
sudo ./install.sh
````

> _**Make sure to updated the Git Configurations in the Code as need.**_

> _**You may get prompted for restart of service by apt-get if using first time.**_

---

## `update.sh`

Performs a clean and efficient system update to keep tools and packages current. Here are the actions it takes:

* Performs System package update
* Performs Full-upgrade
* Performs Autoremove
* Updates:

  * Searchsploit Local DB `searchsploit -u`
  * Nmap NSE scripts `nmap --script-updatedb`
  * Local Filesystem location DB `updatedb`

### Usage:

```bash
sudo ./update.sh
```

---

## `croncreator.sh`

Sets up a **monthly cron job** to auto-run `update.sh`. Here is what it does:

1. Verifies `root` permissions
2. Copies `update.sh` to `/root/.update.sh`
3. Sets correct file permissions
4. Creates a cronjob to run it monthly:

   * **Schedule**: `0 0 1 * *`
   * **Log Output**: `/var/log/update.log`

### Usage:

```bash
sudo ./croncreator.sh
```

---

## `get-tools.sh`

Downloads an arsenal of **additional Linux and Windows post-exploitation tools** into a structured directory for CTFs, assessments, and real-world ops.

### Toolsets:

* `linux` – PEAS, LinEnum, pspy, GTFOBins, and more
* `windows` – Sysinternals, winPEAS, PowerSploit, Rubeus, etc.
* `misc` – BloodHound, DNSCat2, SharpHound, Chisel, Ligolo
* `all` – Runs all three above

### Usage:

```bash
sudo ./get-tools.sh [linux|windows|misc|all]
```

---

## `bashrc`

Custom Bash configuration that:

* Improves prompt visibility
* Enables color and shortcuts
* Can be optionally applied via `install.sh`

*The original is available as `bashrc-backup` in case of any issues.*

---

## `nanorc`

* Improves the default Nano experience and UI.
* Enable better Mouse and Keyboard Control.
* Enables syntax highlighting for many file types
* Can be installed automatically via `install.sh`

---

## Requirements

* **Root Privileges**: All scripts must be run with `sudo` privileges or as root user.
* **OS**: Kali/Ubuntu Linux (bare-metal, Virtual-Machine, or WSL2 if desired)
* **Internet Access**: Required for fetching tools from GitHub and external sources.

---

## Disclaimer

- These scripts are provided **as-is** with no guarantees. **Use responsibly and legally.**
- They are powerful and designed for advanced users, pentesters, and red teamers.
- Always inspect and review scripts before running them on critical environments.


---
