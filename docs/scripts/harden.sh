#!/bin/bash
# ============================================
# Company IT Lab - System Hardening Script
# ============================================

echo "🔒 Starting System Hardening..."

# 1. Update all packages
echo "[1/8] Updating system packages..."
apt update && apt upgrade -y
echo "✅ Packages updated"

# 2. Enable automatic security updates
echo "[2/8] Configuring unattended upgrades..."
apt install unattended-upgrades -y
echo 'Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
};
Unattended-Upgrade::Automatic-Reboot "false";' > /etc/apt/apt.conf.d/50unattended-upgrades
echo "✅ Auto security updates enabled"

# 3. Set global password policy
echo "[3/8] Setting password policies..."
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   7/' /etc/login.defs
sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   14/' /etc/login.defs
echo "✅ Password policy set: 90 day max, 7 day min"

# 4. Disable unused services
echo "[4/8] Disabling unused services..."
for service in bluetooth cups avahi-daemon; do
    if systemctl is-enabled "$service" 2>/dev/null; then
        systemctl disable "$service" 2>/dev/null
        systemctl stop "$service" 2>/dev/null
        echo "  Disabled: $service"
    fi
done

# 5. Secure shared memory
echo "[5/8] Securing shared memory..."
if ! grep -q "/run/shm" /etc/fstab; then
    echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" >> /etc/fstab
fi

# 6. Audit open ports
echo "[6/8] Open ports audit:"
ss -tulnp

# 7. Check for world-writable files
echo "[7/8] Checking for world-writable files in /etc..."
find /etc -xdev -type f -perm -o+w 2>/dev/null

# 8. Create hardening report
echo "[8/8] Generating hardening report..."
cat > /var/log/hardening_report.txt << EOF
=== System Hardening Report ===
Date: $(date)
Hostname: $(hostname)
OS: $(lsb_release -d | cut -f2)

Password Policy:
- Max days: 90
- Min days: 7
- Warning: 14 days

Firewall: $(ufw status | head -1)
Fail2ban: $(systemctl is-active fail2ban)
SSH Root Login: $(grep '^PermitRootLogin' /etc/ssh/sshd_config)
SSH Password Auth: $(grep '^PasswordAuthentication' /etc/ssh/sshd_config)

Open Ports:
$(ss -tulnp | grep LISTEN)
EOF

cat /var/log/hardening_report.txt
echo "✅ Hardening complete!"
