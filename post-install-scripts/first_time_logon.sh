# $1=user $2=password

### Make the first time flag editable only by root so that abuse of this script is not accessible to already setup devices. ###
if [ -f "/home/$1/.first-logon-done" ]; then
    sudo chown root:root "/home/$1/.first-logon-done"
    sudo chmod 644 "/home/$1/.first-logon-done"
fi
### Make this editable only by root so that abuse of this script is not accessible to already setup devices. ###

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

### Configure and Start Docker Compose for GreenBone Scanner. ###
ip_address=$(hostname -I | awk '{print $1}')
composeDIR="/home/$1/composeFiles"
mkdir $composeDIR
curl --http1.1 -o $composeDIR/compose.yaml https://raw.githubusercontent.com/CriticalWombat/KickScan/dev/yaml/compose.yaml
docker compose -f $composeDIR/compose.yaml up -d

# Clear the terminal screen
clear

# Inform the user about the test
echo "Testing for GreenBone web interface at http://$ip_address:5555..."
echo ""

# Initialize attempt counter
attempt=1
max_attempts=5
sleep_duration=5

# Function to check GreenBone web interface accessibility
check_greenbone() {
    curl -s --head --request GET "http://$ip_address:5555" | grep "200 OK" > /dev/null
    return $?
}

# Loop to attempt checking up to max_attempts times
while [ $attempt -le $max_attempts ]; do
    echo "Attempt $attempt of $max_attempts..."
    if check_greenbone; then
        echo "GreenBone configuration has been completed! Navigate to http://$ip_address:5555 in a web browser."
        echo ""
        echo ""
        exit 0
    else
        echo "GreenBone web interface is not currently accessible at http://$ip_address:5555..."
        attempt=$((attempt+1))
        if [ $attempt -le $max_attempts ]; then
            echo "Retrying in $sleep_duration seconds..."
            sleep $sleep_duration
        fi
    fi
done

# If it reaches here, all attempts have failed
echo ""
echo "Failed to access GreenBone web interface after $max_attempts attempts."
echo ""
echo ""
echo "Manual troubleshooting is required..."
echo ""
echo "Docker Compose is located at $composeDIR/compose.yaml"
echo ""
docker ps 
echo ""
echo ""
exit 1
### Configure and Start Docker Compose for GreenBone Scanner. ###

echo ""
echo "Changing admin password for Greenbone interface to match your bilge password..."
docker compose -f $composeDIR/compose.yaml exec -u gvmd gvmd gvmd --user=admin --new-password=$2
echo ""
echo "Done!"

# Delete this script
sudo rm -f -- "$0"