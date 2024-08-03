### Make this editable only by root so that abuse of this script is not accessible to already setup devices. ###
if [ -f "/home/nexigen/.first-logon-done" ]; then
    sudo chown root:root "/home/nexigen/.first-logon-done"
    sudo chmod 644 "/home/nexigen/.first-logon-done"
fi
### Make this editable only by root so that abuse of this script is not accessible to already setup devices. ###

##### Update /etc/issue to remove first time logon info #####
sudo tee /etc/issue > /dev/null << 'EOF'
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
sudo rm -f -- "$0"
