# Phase 10 — System Hardening

## Overview
Ran a full system hardening script covering package updates, password policies, disabling unused services, and generating an audit report.

## 1. Hardening Report Output
sudo /opt/scripts/harden.sh
cat /var/log/hardening_report.txt

![Hardening Report](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/Full%20Hardening%20Report.png)

## Hardening Checklist
✅ All packages updated
✅ Unattended security upgrades enabled
✅ Password policy set (90 day max, 7 day min)
✅ Root SSH login disabled
✅ Password authentication disabled (keys only)
✅ Unused services disabled
✅ UFW firewall enabled
✅ Fail2ban active
✅ Open ports audited
✅ Shared memory secured
