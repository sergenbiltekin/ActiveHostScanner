# 🔍 ActiveHostScanner  

ActiveHostScanner is a fast and lightweight network scanning tool designed to quickly identify active hosts within a specified IP range.  
It first attempts to detect hosts using ICMP (ping) for rapid discovery. If no response is received, it performs a stealthy TCP SYN scan on commonly open ports, including 22 (SSH), 80 (HTTP), 443 (HTTPS), 445 (SMB), 3389 (RDP), 53 (DNS), and 8080 (Web Services).  
Optimized for speed, ActiveHostScanner runs parallel scans to minimize delays, making it ideal for network administrators, penetration testers, and security professionals.  

## ⚠️ Legal Disclaimer  
This tool is for **authorized use only**. Unauthorized network scanning is illegal.

## 🔧 Dependencies
Requires nmap and ping:
```bash
sudo apt update && sudo apt install nmap iputils-ping -y
```

## 📥 Installation  
```bash
git clone https://github.com/sergenbiltekin/ActiveHostScanner.git
cd ActiveHostScanner
chmod +x activehostscanner.sh
```

## 🛠️ Usage
Run the script with an IP range or multiple subnets:
```bash
./activehostscanner.sh 192.168.1.0/24, 10.10.10.0/24
```

## 📂 Output Files
active_hosts.txt → List of detected active hosts.  
host_scan_summary.txt → Summary of scanned IP ranges.
