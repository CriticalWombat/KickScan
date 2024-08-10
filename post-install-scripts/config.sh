#!/bin/bash

# $1=username $2=password $3=IP

hostname=$(hostname)

# Update /etc/issue with first time logon info
tee /etc/issue >> /dev/null << EOF
 
#========================================================#
# This information will not be visible after first login!
#      ROOT LOGON IS LOCKED BY DEFAULT - USE SUDO!
#                  Welcome to Bilge
#
#
# User Name: $1
# User Password: $2
#
# Hostname: $hostname
# IP Address: $3
#
#
#========================================================#
EOF