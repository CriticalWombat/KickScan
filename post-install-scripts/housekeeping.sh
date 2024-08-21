# $1=user $2=password

### Remove the first time flag so that abuse of this script is not accessible to already setup devices. ###
if [ -f "/home/$1/.first-logon-done" ]; then
    rm -f "/home/$1/.first-logon-done"
fi

### Remove the bashrc lines that contain sensitive first time logon info ###


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