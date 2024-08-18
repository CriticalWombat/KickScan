# user ops
groupadd docker
usermod -aG "$1",wheel,docker "$1"
mkdir /home/"$1"/.ssh
chmod 700 /home/"$1"/.ssh
echo -e 'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGtIefCNwnylwl1ZxT2WJ+BMJ+wCyj52A/HOkxDSxBxhEp6GCfMiqt6o5WijBhidQ4qpUwHeWdpr8KrRA1Hc5eM= ecdsa-key-20240731' > /home/$1/.ssh/authorized_keys
chown -R "$1":"$1" /home/"$1"/.ssh
chmod 0400 /home/"$1"/.ssh/*
echo "$1        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/"$1"
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers