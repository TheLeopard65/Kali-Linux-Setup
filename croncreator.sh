#!/bin/bash
# Author: TheLeopard65

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

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
figlet "PENTESTER'S KALI - LINUX" || echo -e "${YELLOW}(Install 'figlet' to see ASCII banners)${NC}"
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"

if [[ "$(id -u)" -ne 0 ]]; then
    error "Please run this script using ROOT or SUDO (e.g., 'sudo $0')!"
    exit 1
fi

success "Root privileges confirmed."

info "Defining required file path variables..."
SCRIPT_DIR=$(dirname "$(realpath "$0")")
SCRIPT_SRC="$SCRIPT_DIR/update.sh"
SCRIPT_DEST="/root/.update.sh"
LOG_FILE="/var/log/update.log"

if [[ ! -f "$SCRIPT_DIR/update.sh" ]]; then
	error "update.sh not found"
	exit 1
fi

info "Copying update script to root directory..."
if cp "$SCRIPT_SRC" "$SCRIPT_DEST"; then
    success "Script copied to $SCRIPT_DEST"
else
    error "Failed to copy $SCRIPT_SRC to $SCRIPT_DEST"
    exit 1
fi

info "Setting file permissions (700)..."
chmod 700 "$SCRIPT_DEST"
success "Permissions set."

info "Defining cron job..."
JOB="0 0 1 * * $SCRIPT_DEST >> $LOG_FILE 2>&1"

info "Performing final check on file..."
if [[ ! -f "$SCRIPT_DEST" ]]; then
    error "File not found: $SCRIPT_DEST"
    exit 1
fi
success "File verification passed."

info "Installing cron job..."
TMP=$(mktemp)
crontab -l 2>/dev/null | grep -v "$SCRIPT_DEST" > "$TMP" || true
echo "$JOB" >> "$TMP"
if crontab "$TMP"; then
    success "Cron job added successfully!"
else
    error "Failed to install new crontab"
    rm "$TMP"
    exit 1
fi
rm "$TMP"

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
echo -e "${GREEN}[###] Kali-Linux Pentester's Cron-Job creation process is finally complete!${NC}"
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
