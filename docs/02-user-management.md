# Phase 2 — User Account Management

# Overview
Created 10 employees across 3 departments using Linux groups to manage access.

# 1. All Users Created
sudo useradd -m -s /bin/bash -G hr alice
# repeated for all 10 users
cat /etc/passwd

![Users Created](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/Users%20Created.png)
![10 Users](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/Output%20Showing%20all%2010%20users.png)
# 2. Onboarding Script

Automated new employee setup using a bash script.
sudo ./onboard_user.sh

![Onboarding Script](https://github.com/NikJGFrancis/company-it-lab/blob/main/docs/scripts/onboard_user.sh)

# 3. Password Policy Applied
- sudo chage -M 90 -m 7 -W 14 alice
- sudo chage -l alice

![Password Policy](https://github.com/NikJGFrancis/company-it-lab/blob/main/Company%20IT%20Lab%20Screenshots/Set%20Password%20Expiry%20Policy.png)

# Helpdesk Tickets Simulated
- sudo usermod -L grace        # Lock account
- sudo usermod -U grace        # Unlock account
- sudo chage -d 0 bob          # Force password reset
- sudo usermod -aG sales charlie  # Add user to group
