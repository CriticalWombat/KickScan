# Generate a dynamic hostname and save it to an include file
HOSTNAME_PREFIX="Scanner"
ID=$(cat /proc/sys/kernel/random/uuid | cut -d "-" -f 3)
HOSTNAME="${HOSTNAME_PREFIX}-${ID}"
echo "network --bootproto=dhcp --hostname=${HOSTNAME}" > /tmp/host-include.ks

# URL to fetch the username
URL="https://usernameapiv1.vercel.app/api/random-usernames"
# Generate a dynamic username and save it to a temporary file
response=$(curl -s -w "%{http_code}" -o /tmp/username.json $URL)
# Check if the response code is 200
if [ "${response: -3}" == "200" ]; then
    # Extract the JSON part of the response
    json=$(cat /tmp/username.json)
    # Extract username
    username=$(echo $json | grep -oP '"usernames":\["\K[^"]+')
    # Remove trailing underscore using bash parameter expansion
    clean_username=${username%_}
else
    # Set a static username
    clean_username="user-$ID"
fi

# Make password
password=$(tr -dc 'A-Za-z0-9!?%=' < /dev/urandom | head -c 10)
# Add to the include statement
echo "user --name=$clean_username --password=$password --plaintext" > /tmp/user-include.ks