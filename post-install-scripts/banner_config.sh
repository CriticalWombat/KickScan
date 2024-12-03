#!/bin/bash

# $1=username $2=password

hostname=$(hostname)
ip_address=$(hostname -I | awk '{print $1}')

# Update /etc/issue with first time logon info
tee /etc/issue >> /dev/null << EOF
 

             
                                                                
 _____                                                                   _____ 
( ___ )                                                                 ( ___ )
 |   |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|   | 
 |   |                                                                   |   | 
 |   |                                                                   |   |
 |   |          ███████████   ███  ████                                  |   |
 |   |         ░░███░░░░░███ ░░░  ░░███                                  |   |
 |   |          ░███    ░███ ████  ░███   ███████  ██████                |   |
 |   |          ░██████████ ░░███  ░███  ███░░███ ███░░███               |   |
 |   |          ░███░░░░░███ ░███  ░███ ░███ ░███░███████                |   |
 |   |          ░███    ░███ ░███  ░███ ░███ ░███░███░░░                 |   |
 |   |          ███████████  █████ █████░░███████░░██████                |   |
 |   |          ░░░░░░░░░░░  ░░░░░ ░░░░░  ░░░░░███ ░░░░░░                |   |
 |   |                                    ███ ░███                       |   |
 |   |                                  ░░██████                         |   |
 |   |                                      ░░░░░░                       |   |
 |   |                                                                   |   |
 |   |      This information will not be visible after first login!      |   |
 |   |           ROOT LOGON IS LOCKED BY DEFAULT - USE SUDO!             |   |
 |   |                                                                   |   |
 |   |                                                                   |   |
 |___|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|___| 
(_____)                                                                 (_____)

User Name: $1
User Password: $2
Hostname: $hostname
IP Address: $ip_address
EOF