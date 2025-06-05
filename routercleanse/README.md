# routercleanse

## Overview
RouterCleanse is a command-line tool that scans your local network and router for signs of malware, rogue devices, and unsafe open ports.

## Setup
1. Clone the `routercleanse` directory.
2. Run `pip install -r requirements.txt` if a `requirements.txt` is present.
3. Start with `python routercleanse.py` or equivalent script.

## Usage
The tool will map devices on your LAN, check router configuration (via known IPs or UPnP), and log issues to `router_logs/`.
