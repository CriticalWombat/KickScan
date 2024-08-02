mkdir /home/nexigen/greenbone
curl -o /home/nexigen/greenbone/compose.yaml https://raw.githubusercontent.com/CriticalWombat/KickScan/dev/compose.yaml
cd /home/nexigen/greenbone
docker compose -f /home/nexigen/greenbone/compose.yaml up -d
echo 'Config script completed. Check for scanner interface at localhost:5555'
