#!/bin/bash

NEO4J_PASSWORD="Kali@1234567"
BHAPI_CONFIG="/etc/bhapi/bhapi.json"
NEO4J_HOME="/usr/share/neo4j"
NEO4J_BIN="$NEO4J_HOME/bin"
NEO4J_CONF="$NEO4J_HOME/conf"
NEO4J_LOG="$NEO4J_HOME/logs"
NEO4J_DATA="$NEO4J_HOME/data"

echo "[###] BH-N4J-Setup: Setting Neo4j initial password..."
$NEO4J_BIN/neo4j-admin dbms set-initial-password "$NEO4J_PASSWORD"

echo "[###] BH-N4J-Setup: Starting Neo4j service..."
sudo systemctl start neo4j

echo "[###] BH-N4J-Setup: Checking Neo4j service status..."
sudo systemctl status neo4j

echo "[###] BH-N4J-Setup: Updating BloodHound API configuration..."
sudo sed -i "s/\"secret\": \"neo4j\"/\"secret\": \"$NEO4J_PASSWORD\"/" "$BHAPI_CONFIG"

echo "[###] BH-N4J-Setup: Restarting BloodHound service..."
sudo systemctl restart bloodhound

echo "[###] BH-N4J-Setup: BloodHound setup completed successfully!"
