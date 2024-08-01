systemctl start docker && \
mkdir /home/nexigen/greenbone
curl -o /home/nexigen/greenbone/compose.yaml https://raw.githubusercontent.com/CriticalWombat/KickScan/dev/compose.yaml && \
cd /home/nexigen/greenbone && \
docker compose up -d
echo 'Config script completed. Check for scanner interface at localhost:5555'
