#!/bin/bash

NEO4J_PASSWORD="Kali@1234567"
BHAPI_CONFIG="/etc/bhapi/bhapi.json"
NEO4J_HOME="/usr/share/neo4j"
NEO4J_BIN="$NEO4J_HOME/bin"
NEO4J_CONF="$NEO4J_HOME/conf"
NEO4J_LOG="$NEO4J_HOME/logs"
NEO4J_DATA="$NEO4J_HOME/data"

if [[ "$(id -u)" -ne 0 ]]; then
    error "Please run this script using ROOT or SUDO. (For example: 'sudo $0')!"
    exit 1
fi

if ! command -v bloodhound 2>&1; then
	apt -qq install -y bloodhound neo4j openjdk-11-jdk
fi

echo "[###] BH-N4J-Setup: Starting the Neo4j Console."
neo4j console & 2>&1 > /dev/null

echo "[###] BH-N4J-Setup: Setting Neo4j initial password."
$NEO4J_BIN/neo4j-admin set-initial-password "$NEO4J_PASSWORD"

echo "[###] BH-N4J-Setup: Starting Neo4j service."
sudo systemctl enable neo4j
sudo systemctl start neo4j

echo "[###] BH-N4J-Setup: Checking Neo4j service status."
sudo systemctl status neo4j

echo "[###] BH-N4J-Setup: Updating BloodHound API configuration."
sudo sed -i "s/\"secret\": \"neo4j\"/\"secret\": \"$NEO4J_PASSWORD\"/" "$BHAPI_CONFIG"

echo "[###] BH-N4J-Setup: Restarting BloodHound service."
sudo systemctl restart bloodhound

echo "[###] BH-N4J-Setup: BloodHound setup completed successfully!"
