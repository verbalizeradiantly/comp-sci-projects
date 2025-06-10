#!/bin/bash

echo "==== RouterCleanse v0.2 – RouterCleanse Network Health ===="

REPORT_DIR="$HOME/Desktop/routercleanse_logs"
SUMMARY="$REPORT_DIR/router_healthcheck.txt"
mkdir -p "$REPORT_DIR"

ROUTER_IP="192.168.0.1"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

echo "[🔍] Scanning for open ports on router ($ROUTER_IP)..."
nmap -Pn -T4 --open -p- "$ROUTER_IP" > "$REPORT_DIR/nmap_$TIMESTAMP.txt"

echo "[🧠] Checking current DNS settings..."
scutil --dns | grep "nameserver\[[0-9]*\]" > "$REPORT_DIR/dns_servers_$TIMESTAMP.txt"
networksetup -getdnsservers Wi-Fi >> "$REPORT_DIR/dns_servers_$TIMESTAMP.txt"

echo "[🌐] Listing connected devices via ARP table..."
arp -a > "$REPORT_DIR/arp_table_$TIMESTAMP.txt"

echo "[📡] Checking for active UPnP services (local)..."
nmap -sU -p 1900 --script=upnp-info "$ROUTER_IP" > "$REPORT_DIR/upnp_check_$TIMESTAMP.txt"

echo "[🧾] Generating Healthcheck summary..."
echo "==== RouterCleanse Healthcheck – $TIMESTAMP ====" > "$SUMMARY"
echo "" >> "$SUMMARY"
echo "✓ Router IP: $ROUTER_IP" >> "$SUMMARY"
echo "✓ Port scan saved to: nmap_$TIMESTAMP.txt" >> "$SUMMARY"
echo "✓ DNS config saved to: dns_servers_$TIMESTAMP.txt" >> "$SUMMARY"
echo "✓ ARP list saved to: arp_table_$TIMESTAMP.txt" >> "$SUMMARY"
echo "✓ UPnP check saved to: upnp_check_$TIMESTAMP.txt" >> "$SUMMARY"
echo "" >> "$SUMMARY"
echo "Next Version: Will include MAC/device lookup, geolocation, threat detection, and MAC change alerts." >> "$SUMMARY"

echo "[✅] Scan complete. Logs and healthcheck saved to $REPORT_DIR"
