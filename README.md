# 🚀 ActiveHostScanner  

ActiveHostScanner is a fast and lightweight tool for detecting active hosts in a network.  
It uses **ICMP (ping)** for quick detection and falls back to **TCP SYN scan** on common ports if needed.

## ⚠️ Legal Disclaimer  
This tool is for **authorized use only**. Unauthorized network scanning is illegal.

## 🚀 Installation  
```bash
git clone https://github.com/sergenbiltekin/ActiveHostScanner.git
cd ActiveHostScanner
chmod +x activehostscanner.sh
```

---

## 🛠️ Usage
Run the script with an IP range or multiple subnets:
```bash
./activehostscanner.sh 192.168.1.0/24, 10.10.10.0/24
```

---

## 📂 Output Files
active_hosts.txt → List of detected active hosts.  
host_scan_summary.txt → Summary of scanned IP ranges.

---

## 🔧 Dependencies
Requires nmap and ping:
```bash
sudo apt update && sudo apt install nmap iputils-ping -y
```
