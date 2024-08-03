### Configure and Start Docker Compose for GreenBone Scanner. ###

mkdir /home/nexigen/greenbone
curl -o /home/nexigen/greenbone/compose.yaml https://raw.githubusercontent.com/CriticalWombat/KickScan/dev/yaml/compose.yaml
docker compose -f /home/nexigen/greenbone/compose.yaml up -d

# Ensure the script exits properly to allow user login to complete
exec "$SHELL"
ip_address=$(hostname -I | awk '{print $1}')
echo ""
echo "Docker configurator has completed. Check for the GreenBone scanner interface at http://$ip_address:5555" 
echo ""
### Configure and Start Docker Compose for GreenBone Scanner. ###