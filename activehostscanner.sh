#!/bin/bash
# Active Host Scanner - Quickly detects accessible hosts in a network

# Legal Disclaimer:
# This script is intended for educational and authorized use only.
# Scanning networks without permission is illegal and may violate laws.
# Use this tool only on networks where you have explicit authorization.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Define common ports for quick scanning
COMMON_PORTS="22,80,443,445,3389,25,53,110,139,8080"

# Function to check if host is active using ping
function ping_scan() {
    local ip=$1
    if ping -c 1 -W 1 $ip &> /dev/null; then
        echo -e "  - ${GREEN}$ip is an active host (ping)${NC}"
        echo "$ip" >> "active_hosts.txt"
        echo "$ip" >> "$temp_file"
    fi
}

# Function to check if host is active using port scan (if ping fails)
function port_scan() {
    local ip=$1
    if nmap -Pn -sS -p $COMMON_PORTS --open $ip | grep "open" &> /dev/null; then
        echo -e "  - ${GREEN}$ip is an active host (port scan)${NC}"
        echo "$ip" >> "active_hosts.txt"
        echo "$ip" >> "$temp_file"
    fi
}

echo -e "${YELLOW}----------------------------------------"
echo -e "     Active Host Scanner"
echo -e "----------------------------------------${NC}"
if [ "$#" -eq 0 ]; then
    echo -e "${RED}ERROR: You forgot to enter IP address ranges!"
    echo -e "Syntax: $0 192.168.1.0/24, 10.10.10.0/24${NC}"
    exit 1
fi

echo -e "${YELLOW}Starting the scan for active hosts...${NC}"
echo ""

# Clear previous files
> "active_hosts.txt"
> "host_scan_summary.txt"

# Split input by both comma and space
IFS=', ' read -r -a ip_ranges <<< "$*"

for range in "${ip_ranges[@]}"; do
    temp_file="temp_$(echo $range | tr '/' '-')".txt
    > "$temp_file"

    echo -e "\n${YELLOW}Scanning $range...${NC}"

    start_time=$(date +%s)
    IFS=$'\n' read -d '' -ra ips <<< $(nmap -n -sL $range | grep 'Nmap scan report for' | awk '{print $5}')
    total_ips=${#ips[@]}

    # First attempt: Ping scan
    for ip in "${ips[@]}"; do
        ping_scan $ip &
    done
    wait

    active_count=$(cat "$temp_file" | wc -l)

    # If no active hosts found, try alternative port scan
    if [[ $active_count -eq 0 ]]; then
        echo -e "${YELLOW}No hosts responded to ping in $range. Trying port scan...${NC}"
        for ip in "${ips[@]}"; do
            port_scan $ip &
        done
        wait
        active_count=$(cat "$temp_file" | wc -l)  # Update active count after port scan
    fi

    end_time=$(date +%s)
    duration=$((end_time - start_time))

    # Store results and summary
    if [[ $active_count -eq 0 ]]; then
        echo -e "\n${RED}No active hosts detected in $range.${NC}"
        echo -e "${YELLOW}It seems like there are no hosts responding to ping or common ports.${NC}"
        echo -e "\n${YELLOW}Summary for $range:${NC}"
        echo -e "  - ${YELLOW}Total IPs Scanned: $total_ips${NC}"
        echo -e "  - ${RED}No active hosts detected${NC}"
        echo -e "  - Scan Duration: ${duration} seconds${NC}"
        echo -e "$range - No active hosts detected" >> "host_scan_summary.txt"
    else
        echo -e "\n${YELLOW}Summary for $range:${NC}"
        echo -e "  - ${YELLOW}Total IPs Scanned: $total_ips${NC}"
        echo -e "  - ${GREEN}Active Hosts: $active_count${NC}"
        echo -e "  - Scan Duration: ${duration} seconds${NC}"
        echo -e "$range - Active Hosts: $active_count" >> "host_scan_summary.txt"
    fi

    rm "$temp_file"

    echo -e "\n${YELLOW}----------------------------------------${NC}"
done

echo -e "\n${GREEN}Scan complete.${NC}"

# Show scan summary immediately after scan completion
echo -e "\n${BOLD}${YELLOW}FINAL SCAN SUMMARY:${NC}"
while IFS= read -r line; do
    if [[ "$line" == *"No active hosts detected"* ]]; then
        echo -e "${RED}$line${NC}"
    else
        echo -e "$line"
    fi
done < host_scan_summary.txt

echo -e "${YELLOW}----------------------------------------${NC}"
echo -e "${YELLOW}All results are logged in 'active_hosts.txt'.${NC}"
echo -e "${YELLOW}Scan summary saved in 'host_scan_summary.txt'.${NC}"
echo -e "${YELLOW}----------------------------------------${NC}"
