### Configure and Start Docker Compose for GreenBone Scanner. ###

mkdir /home/nexigen/greenbone
curl -o /home/nexigen/greenbone/compose.yaml https://raw.githubusercontent.com/CriticalWombat/KickScan/dev/yaml/compose.yaml
docker compose -f /home/nexigen/greenbone/compose.yaml up -d

# Fetch the first IP address
ip_address=$(hostname -I | awk '{print $1}')

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
echo "Manual troubleshooting is required."
exit 1
### Configure and Start Docker Compose for GreenBone Scanner. ###