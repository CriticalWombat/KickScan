# Generate a dynamic hostname and save it to an include file
HOSTNAME_PREFIX="Scanner"
ID=$(cat /proc/sys/kernel/random/uuid | cut -d "-" -f 3)
HOSTNAME="${HOSTNAME_PREFIX}-${ID}"
echo "network --bootproto=dhcp --hostname=${HOSTNAME}" > /tmp/host-include

# Generate a dynamic username and save it to a temporary file
json=$(curl https://usernameapiv1.vercel.app/api/random-usernames)
# Extract username using grep and sed
username=$(echo $json | grep -oP '"usernames":\["\K[^"]+')
# Remove trailing underscore using bash parameter expansion
clean_username=${$username%_}
# Make password
password=$(tr -dc 'A-Za-z0-9!?%=' < /dev/urandom | head -c 10)
# Add to the include statement
echo "user --name=$clean_username --password=$password --plaintext" > /tmp/user-include