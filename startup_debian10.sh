#!/bin/bash

# System upgrade
apt update
apt -y upgrade

# environment variable
cat << EOF >> /root/.bashrc

# The following environment variables have been added by the startup script.
export TERM=vt100
EOF

# Configure public key authentication #{{{
PUB_KEY=`cat << EOF
ssh-ed25519
AAAAC3NzaC1lZDI1NTE5AAAAIAgYWFVnhTttW1/t3MfVP0HWh7NUNbZ4SQqCzx4Jlxhc
junk@Quorra
EOF
`

# root
mkdir -p /root/.ssh
chmod 700 /root/.ssh

echo $PUB_KEY > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# admin
ADMIN_HOME=/home/admin

useradd -m -k /root -G sudo admin -s /bin/bash

# create temporary admin password
#apt install -y whois
#mkpasswd admin
echo 'admin:Nw4e5S' | chpasswd
chage -d 0 admin

mkdir -p ${ADMIN_HOME}/.ssh
chmod 700 ${ADMIN_HOME}/.ssh

echo $PUB_KEY > ${ADMIN_HOME}/.ssh/authorized_keys
chmod 600 ${ADMIN_HOME}/.ssh/authorized_keys
#}}}

# rewriting ssh server settings #{{{
SSHD_FILE='/etc/ssh/sshd_config'

# disable root login
PRL='PermitRootLogin'
sed -i -e "s|^$PRL yes|$PRL forced-commands-only|" $SSHD_FILE

# disable password authentication
PWA='PasswordAuthentication'
sed -i -e "s|^#$PWA yes|$PWA no|" $SSHD_FILE

systemctl restart ssh
#}}}

# Install docker #{{{
# Docker
apt -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt update
apt install -y docker-ce

systemctl enable docker

# Docker-Compose
VER="1.25.5"
S1="https://github.com/docker/compose/releases/download/"
S2="$VER/docker-compose-$(uname -s)-$(uname -m)"
SRC="$S1$S2"
DST="/usr/local/bin/docker-compose"

curl -L $SRC -o $DST
chmod +x $DST

# Add docker group to admin
usermod -aG docker admin
#}}}

# install git
apt -y install git
