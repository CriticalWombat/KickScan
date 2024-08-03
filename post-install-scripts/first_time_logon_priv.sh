##### Update /etc/issue to remove first time logon info #####
cat << 'EOF' > /etc/issue
__  ___      _       _____                 
| |/ (_)    | |     / ____|                
| ' / _  ___| | __ | (___   ___ __ _ _ __  
|  < | |/ __| |/ /  \___ \ / __/ _` | '_ \ 
| . \| | (__|   <   ____) | (_| (_| | | | |
|_|\_\_|\___|_|\_\ |_____/ \___\__,_|_| |_|
                                            
                                            
                        Welcome to KickScan


EOF
##### Update /etc/issue to remove first time logon info #####

# Delete this script since setuid is set and allows user execution with root permission
rm -- "$0"