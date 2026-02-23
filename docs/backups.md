# Phase 7 — Automated Backups & Disaster Recovery

## Overview
Built an automated backup system using tar, rsync, and cron. Simulated accidental file deletion and restored from backup.

## 1. Backup Script Running Successfully
sudo /opt/scripts/backup.sh
cat /var/log/company_backup.log

![Backup Running](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/Backup%20Script%20Running%20with%20successful%20log%20output.png)

## 2. Disaster Recovery — Delete and Restore
# Simulated disaster
sudo rm -rf /company/shared/hr/*

# Restored from backup
sudo tar -xzf /var/backups/company/latest.tar.gz -C /
ls /company/shared/hr/

![Disaster Recovery](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/Before%20Deletion.png)
![After Restoration](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/After%20Restoration.png)

## Cron Schedule
# Runs every night at 2:00 AM
0 2 * * * /opt/scripts/backup.sh
