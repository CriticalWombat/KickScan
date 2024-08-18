# $1=user $2=password

### Make the first time flag editable only by root so that abuse of this script is not accessible to already setup devices. ###
if [ -f "/home/$1/.first-logon-done" ]; then
    sudo chown root:root "/home/$1/.first-logon-done"
    sudo chmod 644 "/home/$1/.first-logon-done"
fi

##### Update /etc/issue to remove first time logon info #####
sudo tee /etc/issue > /dev/null << 'EOF'

////////////////////////////////////////////////////
//  Welcome to                                    //
//                                                //
//   ███████████   ███  ████                      //
//  ░░███░░░░░███ ░░░  ░░███                      //
//   ░███    ░███ ████  ░███   ███████  ██████    //
//   ░██████████ ░░███  ░███  ███░░███ ███░░███   //
//   ░███░░░░░███ ░███  ░███ ░███ ░███░███████    //
//   ░███    ░███ ░███  ░███ ░███ ░███░███░░░     //
//   ███████████  █████ █████░░███████░░██████    //
//  ░░░░░░░░░░░  ░░░░░ ░░░░░  ░░░░░███ ░░░░░░     //
//                            ███ ░███            //
//                           ░░██████             //
//                            ░░░░░░              //
//                                                //
//                                          v0.0  //
////////////////////////////////////////////////////



EOF

# Delete this script
sudo rm -f -- "$0"