#!/bin/bash

# Configure public key authentication for root #{{{
mkdir -p /root/.ssh
chmod 700 /root/.ssh

PUB_KEY=`cat << EOF
ssh-ed25519
AAAAC3NzaC1lZDI1NTE5AAAAIAgYWFVnhTttW1/t3MfVP0HWh7NUNbZ4SQqCzx4Jlxhc
junk@Quorra
EOF
`

echo $PUB_KEY > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
#}}}

# System upgrade
apt update
apt -y upgrade

# install git
apt -y install git

# environment variable
cat << EOF >> /root/.bashrc

# The following environment variables have been added by the startup script.
export TERM=vt100
EOF

# Clone vultr-scripts
git clone https://github.com/junk-e/vultr-srcipts.git /root
