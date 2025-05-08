#!/bin/bash


# This script automates the installation and configuration of Prometheus Node Exporter
# on a Solana validator. It is designed to be lightweight and secure by default.
#
# The script performs the following main steps:
# 1. Checks for essential command-line utilities (wget, tar, systemctl, useradd).
# 2. Creates a dedicated system user 'node_exporter' if it doesn't exist.
# 3. Downloads the specified version of Node Exporter.
# 4. Extracts the downloaded archive and installs the binary to /opt/node_exporter.
# 5. Sets appropriate ownership and permissions for the installed files.
# 6. Creates a systemd service file for Node Exporter:
#    - Configures the service to run as the 'node_exporter' user.
#    - Binds Node Exporter to listen on 127.0.0.1:9100 by default.
#    - Selectively enables a minimal set of useful collectors (cpu, meminfo,
#      filesystem, loadavg, netdev) and disables others to reduce overhead.
# 7. Reloads systemd, enables the Node Exporter service to start on boot,
#    and starts the service.
# 8. Verifies that Node Exporter is running and metrics are accessible.


set -euo pipefail

# Constants
NODE_EXPORTER_VERSION="1.7.0"
USER="node_exporter"
INSTALL_DIR="/opt/node_exporter"
SERVICE_FILE="/etc/systemd/system/node_exporter.service"
LISTEN_ADDR="127.0.0.1:9100" # Use 0.0.0.0 to open to remote then lock down with firewall

# Helper: log function
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Check for required commands
for cmd in wget tar systemctl useradd; do
  if ! command -v "$cmd" &>/dev/null; then
    log "❌ Error: Required command '$cmd' not found. Please install it first."
    exit 1
  fi
done

# Create user if it doesn't exist
if id "$USER" &>/dev/null; then
  log "👤 User '$USER' already exists. Skipping user creation."
else
  log "👤 Creating system user '$USER'..."
  sudo useradd -rs /bin/false "$USER"
fi

# Download and extract Node Exporter
cd /tmp
ARCHIVE="node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"
URL="https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/${ARCHIVE}"

log "📦 Downloading Node Exporter v${NODE_EXPORTER_VERSION}..."
if ! wget -q "$URL"; then
  log "❌ Failed to download Node Exporter from $URL"
  exit 1
fi

log "📂 Extracting archive..."
tar -xzf "$ARCHIVE"

# Move binary into place
log "📁 Installing to $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"
sudo cp "node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter" "$INSTALL_DIR"
sudo chown -R "$USER":"$USER" "$INSTALL_DIR"

# Cleanup
rm -rf "node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64" "$ARCHIVE"

# Create systemd service
log "🧾 Creating systemd service..."
sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=$USER
Group=$USER
Type=simple
# Limit to base useful data
ExecStart=$INSTALL_DIR/node_exporter --web.listen-address=$LISTEN_ADDR
  --collector.disable-defaults \
  --collector.cpu \
  --collector.meminfo \
  --collector.filesystem \
  --collector.loadavg \
  --collector.netdev

Restart=on-failure

[Install]
WantedBy=default.target
EOF


# Start and enable the service
log "🚀 Starting Node Exporter..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable node_exporter

if sudo systemctl start node_exporter; then
  log "✅ Node Exporter started successfully."
else
  log "❌ Failed to start Node Exporter. Check logs with: sudo journalctl -u node_exporter"
  exit 1
fi

# Verify status
sleep 1
if curl -s "http://${LISTEN_ADDR}/metrics" | grep -q "^# HELP"; then
  log "🎯 Node Exporter is running and metrics are available at http://${LISTEN_ADDR}/metrics"
else
  log "⚠️ Node Exporter started but metrics not found. Check service logs."
fi

log "ℹ️ You can monitor the service using: sudo systemctl status node_exporter"