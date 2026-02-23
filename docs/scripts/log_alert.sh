#!/bin/bash
# ============================================
# Company IT Lab - Log Alert Script
# Detects brute force and suspicious activity
# ============================================

THRESHOLD=5    # Alert after 5 failed attempts from same IP
AUTH_LOG="/var/log/auth.log"
ALERT_LOG="/var/log/security_alerts.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "=== Security Scan: $DATE ===" >> "$ALERT_LOG"

# Find IPs with multiple failed attempts in the last hour
echo "Checking for brute force attempts..."
SUSPICIOUS_IPS=$(grep "Failed password" "$AUTH_LOG" | \
    grep "$(date '+%b %e')" | \
    awk '{print $(NF-3)}' | \
    sort | uniq -c | sort -rn | \
    awk -v threshold="$THRESHOLD" '$1 >= threshold {print $2, "attempts:", $1}')

if [[ -n "$SUSPICIOUS_IPS" ]]; then
    echo "⚠️  ALERT: Suspicious IPs detected:" | tee -a "$ALERT_LOG"
    echo "$SUSPICIOUS_IPS" | tee -a "$ALERT_LOG"
else
    echo "✅ No suspicious activity detected." | tee -a "$ALERT_LOG"
fi

# Check for successful root logins (should be zero)
ROOT_LOGINS=$(grep "Accepted.*root" "$AUTH_LOG" | wc -l)
if [[ $ROOT_LOGINS -gt 0 ]]; then
    echo "🚨 CRITICAL: Root login detected! Count: $ROOT_LOGINS" | tee -a "$ALERT_LOG"
fi
