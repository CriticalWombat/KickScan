# user ops
groupadd docker
usermod -aG "$1",wheel,docker "$1"
mkdir /home/"$1"/.ssh
chmod 700 /home/"$1"/.ssh
echo -e ' ' > /home/$1/.ssh/authorized_keys
chown -R "$1":"$1" /home/"$1"/.ssh
chmod 0400 /home/"$1"/.ssh/*
echo "$1        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/"$1"
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

### Append these lines to user's bashrc to trigger a first time logon response ###
cat <<EOL >> /home/"$1"/.bashrc
if [ ! -f "/home/"$1"/.first-logon-done" ]; then
    sudo touch "/home/"$1"/.first-logon-done"
    /usr/local/bin/housekeeping.sh "$1"
fi
EOL