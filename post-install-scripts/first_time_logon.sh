### Configure and Start Docker Compose for GreenBone Scanner. ###
mkdir /home/nexigen/greenbone
curl -o /home/nexigen/greenbone/compose.yaml https://raw.githubusercontent.com/CriticalWombat/KickScan/dev/yaml/compose.yaml
docker compose -f /home/nexigen/greenbone/compose.yaml up -d
echo ""
echo "Docker configurator has completed. Check for the GreenBone scanner interface at https://$ip_address:5555" 
echo ""
### Configure and Start Docker Compose for GreenBone Scanner. ###