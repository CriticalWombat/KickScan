### THIS SCRIPT IS IN PLACE OF A FUTURE PACKAGE HANDLER / SELECTION MODULE ###

### This will be designed to reflect the selection of 'bilgetools' and call the bilgetools scripts appropriately

### Call GreenBone Scanner setup 
curl --http1.1 -o /tmp/GreenBoneScanner.sh https://raw.githubusercontent.com/CriticalWombat/KickScan/MinimalGreenBone/BilgeTools/GreenBoneScanner.sh
chmod +x /tmp/GreenBoneScanner.sh
/tmp/GreenBoneScanner.sh