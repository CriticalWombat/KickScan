### Configure and Start Docker Compose for GreenBone Scanner. ###

#TODO: add wait time before changing interface password
#TODO: Incorporate log level changes for openvas 

# Get the primary IP address of the host
ip_address=$(hostname -I | awk '{print $1}')

# Get the username of the logged-in user
username=$(whoami)

# Define variables for the compose directory and file
composeDIR="/home/$username/composeFiles"
composefile="GreenBoneScanner.yaml"

# Create the compose directory
mkdir -p $composeDIR
if [ $? -ne 0 ]; then
    echo "Error: Failed to create directory $composeDIR."
    exit 1
fi

# Download the Docker Compose YAML file
curl --http1.1 -o $composeDIR/$composefile https://raw.githubusercontent.com/CriticalWombat/KickScan/dev/yaml/$composefile
if [ $? -ne 0 ]; then
    echo "Error: Failed to download Docker Compose file from the specified URL."
    exit 1
fi

# Start Docker Compose
docker compose -f $composeDIR/$composefile up -d
if [ $? -ne 0 ]; then
    echo "Error: Docker Compose failed to start."
    exit 1
fi

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
        echo ""
        echo "Generating a random password for Greenbone interface..."
        random_password=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 10)
        echo "Generated password: $random_password"
        docker compose -f $composeDIR/$composefile exec -u gvmd gvmd gvmd --user=admin --new-password="$random_password"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to change the admin password."
            exit 1
        fi
        echo ""
        echo "Done!"
        echo ""
        echo "GreenBone configuration has been completed! Navigate to http://$ip_address:5555 in a web browser."
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
echo "Manual troubleshooting is required..."
echo ""
echo "Docker Compose is located at $composeDIR/$composefile"
echo ""
docker ps 
echo ""
echo ""
exit 1
