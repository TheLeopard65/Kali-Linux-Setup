#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: run as root" >&2
  exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
  apt-get update -qq >/dev/null 2>&1 || { echo "Error: apt-get update failed" >&2; exit 1; }
  apt-get install -qq -y unzip >/dev/null 2>&1 || { echo "Error: failed to install unzip" >&2; exit 1; }
fi

fetch_sources(){
  wget -q -O /tmp/nanorc.zip https://github.com/scopatz/nanorc/archive/master.zip || { echo "Error: wget failed" >&2; exit 1; }
  mkdir -p /usr/share/nano/
  cd /usr/share/nano/ || { echo "Error: cannot access /usr/share/nano" >&2; exit 1; }
  unzip -o /tmp/nanorc.zip >/dev/null 2>&1 || { echo "Error: unzip failed" >&2; exit 1; }
  mv nanorc-master/* ./ || { echo "Error: move files failed" >&2; exit 1; }
  rm -rf nanorc-master /tmp/nanorc.zip
}

update_nanorc(){
  NANORC_FILE=/etc/nanorc
  INCLUDE_LINE='include "/usr/share/nano/*.nanorc"'
  touch "$NANORC_FILE" || { echo "Error: cannot write to $NANORC_FILE" >&2; exit 1; }
  if ! grep -qF "$INCLUDE_LINE" "$NANORC_FILE"; then
    echo "$INCLUDE_LINE" >> "$NANORC_FILE" || { echo "Error: failed to update $NANORC_FILE" >&2; exit 1; }
  fi
}

fetch_sources
update_nanorc
