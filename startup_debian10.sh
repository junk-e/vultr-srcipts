#!/bin/bash

# system upgrade
apt update
apt -y upgrade

# install git
apt -y install git

# environment variable
cat << EOF >> /root/.bashrc

export TERM=vt100
EOF

# clone vultr-scripts
git clone https://github.com/junk-e/vultr-srcipts.git
