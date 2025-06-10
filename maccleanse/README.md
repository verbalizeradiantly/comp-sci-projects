# maccleanse

This folder contains the `maccleanse` project.

> **Note**: This project was developed with assistance from AI tools (e.g., ChatGPT), but the architecture, intent, and integration were authored by me.

## Overview
The aim has been to create a malware analysis and system cleanup script for my old secondary macbook air (which has seen better days! Years old on a fairly old OS), via a fairly simple process of checking for rogue processes, tracking network activity and inspecting key config files for anomalies. 

The next step will be to get my apple developer license so I can ensure root access, as given its' outdated security infrastructure this tool only suffices on a surface level- perhaps a losing battle, but it's been fun to try. 

## Setup
1. Clone the `maccleanse` folder.
2. Make sure you have Python 3 installed.
3. Run `chmod +x maccleanse.sh` and execute it via `./maccleanse.sh`.

## Usage
MacCleanse will log system activity, highlight suspicious processes, and optionally perform cleanup tasks. Output is stored in `logs/`.

## ⚠️ Compatibility Notice

This version of **MacCleanse** is specifically tailored for an older Mac model and OS:

- ✅ Tested on: macOS Sierra (ver. 10.13.6)
- ✅ Hardware: Intel-based Mac (pre-2020)
- ❌ Not guaranteed to work on Apple Silicon (M1/M2)
- ❌ Not tested on macOS Big Sur or later

A universal or updated build is planned for future versions.

Please test cautiously and report issues via the GitHub Issues tab.
 
