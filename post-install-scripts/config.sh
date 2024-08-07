#!/bin/bash

# $1=username $2=password $3=IP

hostname=$(hostname)

# user ops
groupadd docker
usermod -aG $1,wheel,docker $1 
mkdir /home/$1/.ssh
chmod 700 /home/$1/.ssh
echo -e 'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGtIefCNwnylwl1ZxT2WJ+BMJ+wCyj52A/HOkxDSxBxhEp6GCfMiqt6o5WijBhidQ4qpUwHeWdpr8KrRA1Hc5eM= ecdsa-key-20240731' > /home/$1/.ssh/authorized_keys
chown -R $1:$1 /home/$1/.ssh
chmod 0400 /home/$1/.ssh/*
echo "$1        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/$1
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers


# package ops
yum update -y
yum install -y sudo yum-utils vim
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
yum clean all

systemctl enable docker

# Update /etc/issue with first time logon info
tee /etc/issue >> /dev/null << EOF
 

#==============================================#

# Welcome to KickScan
# This information will not be visible after first login!

# Hostname: $hostname
# IP Address: $3

# User Name: $1
# User Password: $2

# ROOT LOGON IS LOCKED BY DEFAULT - USE SUDO!

#==============================================#
EOF