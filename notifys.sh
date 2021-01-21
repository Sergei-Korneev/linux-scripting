#Memory
if [[ $(cat /proc/meminfo | grep MemAvailable | awk '{ printf "%.0f" ,$2/1024 }') -lt 3000 ]]; then paplay '/home/sergei/mysounds/memorylow.ogg' ;fi

#Temp 

if [[ $(cat /sys/class/thermal/thermal_zone*/temp | awk 'NR == 1' |awk '{ printf "%.0f" ,$1/1000}') -gt 70 ]]; then paplay '/home/sergei/mysounds/temp_is_above70.ogg' ;fi
