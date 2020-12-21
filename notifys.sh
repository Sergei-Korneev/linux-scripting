#8000
if [[ $(cat /proc/meminfo | grep MemAvailable | awk '{ printf "%.0f" ,$2/1024 }') < 3000 ]]; then paplay '/home/sergei/mysounds/memorylow.ogg' ;fi

