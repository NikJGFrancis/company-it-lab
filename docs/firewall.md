# Phase 6 — Firewall & Fail2ban

# Overview
Configured UFW on both VMs with least-privilege rules. Installed fail2ban to automatically ban IPs with repeated failed login attempts.

# 1. UFW Rules on Both VMs
sudo ufw default deny incoming
sudo ufw allow 2222/tcp
sudo ufw allow 80/tcp
sudo ufw enable
sudo ufw status numbered

![Firewall Rules](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/Firewall%20Rules.png)

# 2. Fail2ban Watching SSH
sudo apt install fail2ban -y
sudo fail2ban-client status sshd

![Fail2ban Status](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/fail2ban-client%20status%20sshd.png)

# Fail2ban Config (/etc/fail2ban/jail.local)
[sshd]
enabled = true
port = 2222
maxretry = 3
bantime = 2h
