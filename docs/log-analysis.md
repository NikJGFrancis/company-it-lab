# Phase 9 — Log Analysis & Incident Response

## Overview
Analyzed system logs to identify failed login attempts, suspicious IPs, and potential brute force attacks using grep, awk, and a custom alert script.

## 1. Log Analysis & Alert Output
- sudo grep "Failed password" /var/log/auth.log
- sudo /opt/scripts/log_alert.sh

![Log Analysis](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/Log%20Analysis.png)

## Key Commands Used
# Failed logins today
- sudo grep "Failed password" /var/log/auth.log
- sudo grep "Failed password" /var/log/auth.log | \
- awk '{print $(NF-3)}' | sort | uniq -c | sort -rn | head -10

# Live log monitoring
- sudo tail -f /var/log/auth.log
- sudo journalctl -f
