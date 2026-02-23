# Phase 1 — VM Setup

# Overview
Two Ubuntu Server 22.04 VMs created in VirtualBox to simulate a small company network.

| VM | Role | IP | OS |
|---|---|---|---|
| fileserver | File Server | 10.0.0.10 | Ubuntu Server 22.04 |
| webserver | Web Server | 10.0.0.20 | Ubuntu Server 22.04 |

# 1. Created Both VMs in VirtualBox

![VMs Created](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/VMS%20Created.png)

# 2. Configured Static IPs
- sudo nano /etc/netplan/00-installer-config.yaml
- sudo netplan apply
- ip a

![Static IP Configuration](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/VM1%20Static-IP.png)
![Static IP VM2](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/VM2%20Static%20IP.png)

# 3. Verified Connectivity Between VMs
- ping 10.0.0.20
- ping 10.0.0.10

![Ping Test](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/Ping%20Test.png)
