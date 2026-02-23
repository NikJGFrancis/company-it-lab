#!/bin/bash
# ============================================
# Company IT Lab - Employee Onboarding Script
# Author: IT Admin
# Usage: sudo ./onboard_user.sh
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[ERROR] This script must be run as root.${NC}"
    exit 1
fi

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}   Company IT - New Employee Onboarding${NC}"
echo -e "${YELLOW}========================================${NC}"

# Gather info
read -p "Enter new employee's username: " USERNAME
read -p "Enter full name: " FULLNAME
read -p "Enter department (hr/engineering/sales): " DEPARTMENT
read -s -p "Enter temporary password: " TEMPPASS
echo ""

# Validate department
if [[ ! "$DEPARTMENT" =~ ^(hr|engineering|sales)$ ]]; then
    echo -e "${RED}[ERROR] Invalid department. Choose: hr, engineering, or sales${NC}"
    exit 1
fi

# Create user
useradd -m -s /bin/bash -G "$DEPARTMENT" -c "$FULLNAME" "$USERNAME"
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}[OK] User '$USERNAME' created.${NC}"
else
    echo -e "${RED}[ERROR] Failed to create user.${NC}"
    exit 1
fi

# Set password and force reset on first login
echo "$USERNAME:$TEMPPASS" | chpasswd
passwd --expire "$USERNAME"
echo -e "${GREEN}[OK] Password set. User must change on first login.${NC}"

# Create home directory structure
mkdir -p /home/$USERNAME/{documents,downloads,scripts}
chown -R $USERNAME:$USERNAME /home/$USERNAME/
echo -e "${GREEN}[OK] Home directory structure created.${NC}"

# Log the action
echo "$(date) - NEW USER: $USERNAME ($FULLNAME) added to $DEPARTMENT" >> /var/log/it_admin.log
echo -e "${GREEN}[OK] Action logged to /var/log/it_admin.log${NC}"

echo ""
echo -e "${GREEN}✅ Onboarding complete for $FULLNAME ($USERNAME)${NC}"
echo -e "Department: ${YELLOW}$DEPARTMENT${NC}"
echo -e "Home Dir: ${YELLOW}/home/$USERNAME${NC}"
