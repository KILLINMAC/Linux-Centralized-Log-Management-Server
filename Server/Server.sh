#!/bin/bash

set -e

echo "========== Log Server Setup =========="

echo "[1/8] Updating packages..."
sudo apt update -y

echo "[2/8] Installing packages..."
sudo apt install -y rsyslog logrotate net-tools

echo "[3/8] Enabling rsyslog network modules..."

sudo sed -i 's/^#module(load="imudp")/module(load="imudp")/' /etc/rsyslog.conf
sudo sed -i 's/^#input(type="imudp" port="514")/input(type="imudp" port="514")/' /etc/rsyslog.conf

sudo sed -i 's/^#module(load="imtcp")/module(load="imtcp")/' /etc/rsyslog.conf
sudo sed -i 's/^#input(type="imtcp" port="514")/input(type="imtcp" port="514")/' /etc/rsyslog.conf

echo "[4/8] Creating centralized log directory..."

sudo mkdir -p /var/log/centralized

# Correct ownership for Ubuntu
sudo chown syslog:adm /var/log/centralized
sudo chmod 755 /var/log/centralized

echo "[5/8] Configuring rsyslog..."

sudo tee /etc/rsyslog.d/30-centralized.conf >/dev/null <<EOF
\$FileOwner syslog
\$FileGroup adm
\$FileCreateMode 0640
\$DirCreateMode 0755

\$template RemoteLogs,"/var/log/centralized/%HOSTNAME%.log"

*.* ?RemoteLogs
& stop
EOF

echo "[6/8] Configuring logrotate..."

sudo tee /etc/logrotate.d/centralized-logs >/dev/null <<EOF
/var/log/centralized/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 syslog adm
    sharedscripts
    postrotate
        systemctl reload rsyslog >/dev/null 2>&1 || true
    endscript
}
EOF

echo "[7/8] Validating configuration..."

sudo rsyslogd -N1

echo "[8/8] Restarting rsyslog..."

sudo systemctl enable rsyslog
sudo systemctl restart rsyslog

echo
echo "Listening on:"
sudo ss -tuln | grep 514

echo
echo "Setup Complete."