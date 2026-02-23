# Phase 8 — System Monitoring

## Overview
Built a bash monitoring script that checks CPU, RAM, disk usage, service status, and failed login attempts. Scheduled via cron every 15 minutes.

## 1. Health Report Output
sudo /opt/scripts/monitor.sh

![Monitoring Script](https://github.com/NikJGFrancis/company-it-lab/blob/main/docs/scripts/monitor.sh)

## Cron Schedule
# Every 15 minutes
*/15 * * * * /opt/scripts/monitor.sh
