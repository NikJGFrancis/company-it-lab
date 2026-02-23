#!/bin/bash
# ============================================
# Company IT Lab - System Monitoring Script
# Checks: CPU, RAM, Disk, Services, Logins
# ============================================

LOG="/var/log/system_monitor.log"
ALERT_THRESHOLD_CPU=80
ALERT_THRESHOLD_DISK=85
ALERT_THRESHOLD_RAM=90
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Colors for terminal
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   Company IT Lab - System Health Report${NC}"
echo -e "${BLUE}   $DATE${NC}"
echo -e "${BLUE}================================================${NC}"

# --- CPU Usage ---
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
CPU_USAGE=$((100 - CPU_IDLE))
echo -e "\n${YELLOW}[CPU]${NC}"
if [[ $CPU_USAGE -ge $ALERT_THRESHOLD_CPU ]]; then
    echo -e "  Usage: ${RED}${CPU_USAGE}% ⚠️  ALERT${NC}"
    echo "$DATE | ALERT | CPU usage at ${CPU_USAGE}%" >> "$LOG"
else
    echo -e "  Usage: ${GREEN}${CPU_USAGE}% ✅${NC}"
fi

# --- RAM Usage ---
RAM_INFO=$(free -m | grep Mem)
RAM_TOTAL=$(echo $RAM_INFO | awk '{print $2}')
RAM_USED=$(echo $RAM_INFO | awk '{print $3}')
RAM_PERCENT=$((RAM_USED * 100 / RAM_TOTAL))
echo -e "\n${YELLOW}[MEMORY]${NC}"
if [[ $RAM_PERCENT -ge $ALERT_THRESHOLD_RAM ]]; then
    echo -e "  Usage: ${RED}${RAM_USED}MB / ${RAM_TOTAL}MB (${RAM_PERCENT}%) ⚠️  ALERT${NC}"
    echo "$DATE | ALERT | RAM usage at ${RAM_PERCENT}%" >> "$LOG"
else
    echo -e "  Usage: ${GREEN}${RAM_USED}MB / ${RAM_TOTAL}MB (${RAM_PERCENT}%) ✅${NC}"
fi

# --- Disk Usage ---
echo -e "\n${YELLOW}[DISK]${NC}"
while IFS= read -r line; do
    DISK_PERCENT=$(echo "$line" | awk '{print $5}' | cut -d% -f1)
    MOUNT=$(echo "$line" | awk '{print $6}')
    if [[ $DISK_PERCENT -ge $ALERT_THRESHOLD_DISK ]]; then
        echo -e "  $MOUNT: ${RED}${DISK_PERCENT}% ⚠️  ALERT${NC}"
        echo "$DATE | ALERT | Disk $MOUNT at ${DISK_PERCENT}%" >> "$LOG"
    else
        echo -e "  $MOUNT: ${GREEN}${DISK_PERCENT}% ✅${NC}"
    fi
done < <(df -h | grep -vE '^Filesystem|tmpfs|udev|snap')

# --- Service Status ---
echo -e "\n${YELLOW}[SERVICES]${NC}"
SERVICES=("ssh" "smbd" "fail2ban" "cron")
for service in "${SERVICES[@]}"; do
    STATUS=$(systemctl is-active "$service" 2>/dev/null)
    if [[ "$STATUS" == "active" ]]; then
        echo -e "  $service: ${GREEN}RUNNING ✅${NC}"
    else
        echo -e "  $service: ${RED}DOWN ⚠️  ALERT${NC}"
        echo "$DATE | ALERT | Service $service is DOWN" >> "$LOG"
    fi
done

# --- Failed Login Attempts (last 24h) ---
echo -e "\n${YELLOW}[SECURITY - Failed Logins (last 24h)]${NC}"
FAIL_COUNT=$(grep "Failed password" /var/log/auth.log 2>/dev/null | \
    grep "$(date '+%b %e')" | wc -l)
if [[ $FAIL_COUNT -gt 10 ]]; then
    echo -e "  Failed attempts: ${RED}$FAIL_COUNT ⚠️  Possible brute force!${NC}"
    echo "$DATE | SECURITY ALERT | $FAIL_COUNT failed login attempts" >> "$LOG"
else
    echo -e "  Failed attempts today: ${GREEN}$FAIL_COUNT ✅${NC}"
fi

# --- Top 5 Processes by CPU ---
echo -e "\n${YELLOW}[TOP PROCESSES BY CPU]${NC}"
ps aux --sort=-%cpu | head -6 | tail -5 | \
    awk '{printf "  %-20s CPU: %s%%\n", $11, $3}'

# --- Currently Logged In Users ---
echo -e "\n${YELLOW}[ACTIVE SESSIONS]${NC}"
who | awk '{printf "  User: %-15s Terminal: %-10s Login: %s %s\n", $1, $2, $3, $4}'

echo -e "\n${BLUE}================================================${NC}"
echo -e "${BLUE}   Report Complete | Log: $LOG${NC}"
echo -e "${BLUE}================================================${NC}"
