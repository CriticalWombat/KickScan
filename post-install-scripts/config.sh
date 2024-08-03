#!/bin/bash

# user ops
groupadd docker
#useradd -m nexigen Testing ks useradd function
/bin/mkdir /home/nexigen/.ssh
/bin/chmod 700 /home/nexigen/.ssh
/bin/echo -e 'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGtIefCNwnylwl1ZxT2WJ+BMJ+wCyj52A/HOkxDSxBxhEp6GCfMiqt6o5WijBhidQ4qpUwHeWdpr8KrRA1Hc5eM= ecdsa-key-20240731' > /home/nexigen/.ssh/authorized_keys
/bin/chown -R nexigen:nexigen /home/nexigen/.ssh
/bin/chmod 0400 /home/nexigen/.ssh/*
echo "nexigen        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/nexigen
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
usermod -aG nexigen,wheel,docker nexigen

# package ops
yum update -y
yum install -y sudo yum-utils vim
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
yum clean all