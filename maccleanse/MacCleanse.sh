#!/bin/bash
cd ~/Desktop
echo "===== System Info =====" > full_scan.txt
system_profiler SPHardwareDataType SPSoftwareDataType >> full_scan.txt

echo "\n===== Launch Agents & Daemons =====" >> full_scan.txt
find /Library/Launch* ~/Library/Launch* -type f -exec sh -c 'echo "\n--- {} ---"; cat "{}"' \; >> full_scan.txt

echo "\n===== Login Items =====" >> full_scan.txt
osascript -e 'tell application "System Events" to get the name of every login item' >> full_scan.txt

echo "\n===== Suspicious Network Connections =====" >> full_scan.txt
lsof -i -nP | grep ESTABLISHED >> full_scan.txt

echo "\n===== Cron Jobs + Shell Startup Files =====" >> full_scan.txt
crontab -l >> full_scan.txt 2>/dev/null
cat ~/.zshrc ~/.bash_profile ~/.bashrc 2>/dev/null >> full_scan.txt

echo "\n===== Loaded Kernel Extensions =====" >> full_scan.txt
kextstat >> full_scan.txt

echo "\n===== Running Processes =====" >> full_scan.txt
ps aux >> full_scan.txt

echo "\n===== Hidden Directories in Home Folder =====" >> full_scan.txt
find ~/.* -type d >> full_scan.txt

echo "\n===== launchctl List =====" >> full_scan.txt
launchctl list >> full_scan.txt

echo "Done! Scan saved to full_scan.txt on Desktop."

#!/bin/bash
input_file="full_scan.txt"
output_file="healthcheck.txt"

echo "===== MACCLEANSE HEALTHCHECK REPORT =====" > "$output_file"
echo "Scan Date: $(date)" >> "$output_file"
echo >> "$output_file"

flag_if_found () {
    pattern="$1"
    label="$2"
    echo ">>> Checking for $label..." >> "$output_file"
    matches=$(grep -i "$pattern" "$input_file")
    if [ -n "$matches" ]; then
        echo "[!] Suspicious entries found for: $label" >> "$output_file"
        echo "$matches" >> "$output_file"
        echo >> "$output_file"
    else
        echo "[OK] Nothing suspicious found for: $label" >> "$output_file"
        echo >> "$output_file"
    fi
}

flag_if_found "coinhive\\|cryptominer" "Cryptominers"
flag_if_found "com.adobe.*\\.plist" "Adobe background tasks"
flag_if_found "macsfancontrol\\|TG Pro" "Fan control tools"
flag_if_found "launchagents.*\\.sh" "Shell scripts in LaunchAgents"
flag_if_found "dropbox\\|teamviewer\\|zoom" "Remote access tools"
flag_if_found "com\\.apple\\.Terminal\\|zshrc\\|bashrc" "Startup script injection"
flag_if_found "127\\.0\\.0\\.1:\\|0\\.0\\.0\\.0:" "Localhost listeners"
flag_if_found "/usr/local/bin" "Manual installs"
flag_if_found "\\.hidden\\|^\\." "Hidden files"
flag_if_found "root.*launchd" "Root daemons"
flag_if_found "kext" "Kernel extensions"
flag_if_found "VPN\\|tun\\|tap" "Virtual interfaces"

echo "===== SUMMARY & TIPS =====" >> "$output_file"
echo >> "$output_file"
sus_count=$(grep "\\[!\\]" "$output_file" | wc -l)
if [ "$sus_count" -eq 0 ]; then
    echo "[✓] No suspicious items found." >> "$output_file"
else
    echo "[!] $sus_count suspicious categories flagged. Review them above carefully." >> "$output_file"
fi

#!/bin/bash
echo "==== ROGUE PROCESS CHECK ====" > rogue_report.txt
echo "Date: $(date)" >> rogue_report.txt
echo >> rogue_report.txt

echo ">> High CPU/Memory processes:" >> rogue_report.txt
ps aux | awk '$3 > 20 || $4 > 20' >> rogue_report.txt
echo >> rogue_report.txt

echo ">> Suspicious process paths:" >> rogue_report.txt
ps aux | egrep '/tmp/|/var/|/private/|/Users/.*/\\..*/' >> rogue_report.txt
echo >> rogue_report.txt

echo ">> Unsigned or abnormal binary locations:" >> rogue_report.txt
for pid in $(ps ax -o pid=); do
  path=$(lsof -p $pid 2>/dev/null | awk '{print $9}' | grep '^/' | head -n 1)
  if [[ $path != "" && ! $path =~ ^/Applications && ! $path =~ ^/System && ! $path =~ ^/usr && ! $path =~ ^/bin ]]; then
    echo "PID $pid: $path" >> rogue_report.txt
  fi
done

echo >> rogue_report.txt
echo ">> Cron jobs:" >> rogue_report.txt
crontab -l >> rogue_report.txt 2>/dev/null

echo >> rogue_report.txt
echo ">> Shell profile injections:" >> rogue_report.txt
cat ~/.zshrc ~/.bash_profile ~/.bashrc 2>/dev/null | grep -E 'curl|wget|bash|sh|launchctl|osascript|/tmp/' >> rogue_report.txt

echo >> rogue_report.txt
echo ">> Non-Apple launchctl entries:" >> rogue_report.txt
launchctl list | grep -vE '^com.apple|^\\-\\s+' >> rogue_report.txt

echo >> rogue_report.txt
echo ">> DONE. Output saved to rogue_report.txt"
