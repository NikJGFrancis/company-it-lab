# Phase 5 — SSH Hardening

# Overview
Hardened SSH access by changing the default port, disabling root login, enforcing key-based authentication, and restricting access to the IT Admin group only.

# Changes Made to /etc/ssh/sshd_config
Port 2222
PermitRootLogin no
PasswordAuthentication no
AllowGroups it_admin
MaxAuthTries 3
X11Forwarding no

# 1. SSH on Port 2222 Working — Non-Admin Denied
ssh -p 2222 jake@10.0.0.10    # Works
ssh -p 2222 alice@10.0.0.10   # Denied

![SSH Hardening](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/Full%20Hardening%20Report.png)
