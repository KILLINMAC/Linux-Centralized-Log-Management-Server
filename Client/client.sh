#!/bin/bash

set -e

LOG_SERVER_IP="172.31.35.160"
echo "log server can be changed"

echo "========== Client Setup =========="

echo "[1/5] Updating packages..."
sudo apt update -y

echo "[2/5] Installing rsyslog..."
sudo apt install -y rsyslog

echo "[3/5] Configuring forwarding..."

sudo tee /etc/rsyslog.d/50-forward.conf >/dev/null <<EOF
*.* @@${LOG_SERVER_IP}:514
EOF

echo "[4/5] Validating configuration..."

sudo rsyslogd -N1

echo "[5/5] Restarting rsyslog..."

sudo systemctl enable rsyslog
sudo systemctl restart rsyslog

logger "Client $(hostname) successfully connected to centralized log server."

echo
echo "Test log sent."