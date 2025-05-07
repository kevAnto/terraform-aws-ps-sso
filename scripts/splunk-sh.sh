#!/bin/bash
# Splunk Installation and Configuration Script

# Log setup
LOG_FILE="/var/log/splunk-setup.log"
exec > >(tee -a ${LOG_FILE}) 2>&1
echo "Starting Splunk installation at $(date)"

# Set environment variables
SPLUNK_HOME="/opt/splunk"
SPLUNK_USER="splunk"
SPLUNK_GROUP="splunk"
SPLUNK_VERSION="9.0.5"
SPLUNK_BUILD="e9494146ae5c"
SPLUNK_FILENAME="splunk-${SPLUNK_VERSION}-${SPLUNK_BUILD}-Linux-x86_64.tgz"
SPLUNK_URL="https://download.splunk.com/products/splunk/releases/${SPLUNK_VERSION}/linux/${SPLUNK_FILENAME}"
SPLUNK_ADMIN_PASSWORD="ChangeMe123!"

# Create Splunk user and group if they don't exist
echo "Creating Splunk user and group..."
getent group ${SPLUNK_GROUP} >/dev/null || groupadd ${SPLUNK_GROUP}
getent passwd ${SPLUNK_USER} >/dev/null || useradd -m -g ${SPLUNK_GROUP} ${SPLUNK_USER}

# Install dependencies
echo "Installing dependencies..."
yum update -y
yum install -y wget curl tar

# Download Splunk
echo "Downloading Splunk..."
wget -q -O /tmp/${SPLUNK_FILENAME} ${SPLUNK_URL}
if [ $? -ne 0 ]; then
    echo "Failed to download Splunk. Exiting."
    exit 1
fi

# Extract Splunk
echo "Extracting Splunk..."
tar -xzf /tmp/${SPLUNK_FILENAME} -C /opt
if [ $? -ne 0 ]; then
    echo "Failed to extract Splunk. Exiting."
    exit 1
fi

# Set ownership
echo "Setting ownership of Splunk files..."
chown -R ${SPLUNK_USER}:${SPLUNK_GROUP} ${SPLUNK_HOME}

# Create user-seed.conf for automated admin setup
echo "Creating user-seed.conf..."
mkdir -p ${SPLUNK_HOME}/etc/system/local
cat > ${SPLUNK_HOME}/etc/system/local/user-seed.conf << EOF
[user_info]
USERNAME = admin
PASSWORD = ${SPLUNK_ADMIN_PASSWORD}
EOF

# Configure Splunk to start at boot
echo "Configuring Splunk to start at boot..."
cat > /etc/systemd/system/splunk.service << EOF
[Unit]
Description=Splunk Enterprise
After=network.target
Wants=network.target

[Service]
Type=forking
User=${SPLUNK_USER}
Group=${SPLUNK_GROUP}
ExecStart=${SPLUNK_HOME}/bin/splunk start --accept-license --answer-yes --no-prompt
ExecStop=${SPLUNK_HOME}/bin/splunk stop
ExecReload=${SPLUNK_HOME}/bin/splunk restart
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Configure Splunk
echo "Configuring Splunk settings..."
cat > ${SPLUNK_HOME}/etc/system/local/server.conf << EOF
[general]
serverName = $(hostname)
pass4SymmKey = changeme

[sslConfig]
enableSplunkdSSL = true
EOF

# Start Splunk for the first time
echo "Starting Splunk..."
${SPLUNK_HOME}/bin/splunk start --accept-license --answer-yes --no-prompt
if [ $? -ne 0 ]; then
    echo "Failed to start Splunk. Check logs for details."
    exit 1
fi

# Enable boot-start with systemd
echo "Enabling Splunk boot-start..."
systemctl daemon-reload
systemctl enable splunk
systemctl restart splunk

# Verify Splunk is running
echo "Verifying Splunk is running..."
sleep 10
systemctl status splunk

echo "Splunk installation and configuration completed at $(date)"
echo "You can access Splunk Web at http://$(hostname):8000"

# Clean up
echo "Cleaning up installation files..."
rm -f /tmp/${SPLUNK_FILENAME}

exit 0