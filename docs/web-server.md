# Phase 4 — Web Server (Nginx)

# Overview
Installed Nginx on VM2 and created a company intranet page accessible from the internal network.

# 1. Company Intranet Page Live
sudo apt install nginx -y
sudo systemctl enable nginx
curl http://10.0.0.20

![Web Server Live](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/Curl%20Showing%20Company%20Intranet%20Page.png)

# Config Location
- Site config: `/etc/nginx/sites-available/company`
- Web root: `/var/www/company/html/`
- Access log: `/var/log/nginx/company_access.log`
- Error log: `/var/log/nginx/company_error.log`
