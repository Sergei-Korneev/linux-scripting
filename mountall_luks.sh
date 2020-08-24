user_=$USER
mount_ () {
#mount all
sudo  echo 
echo -n Password: 
read -s pass
declare -a disks_array
for i in $(ls "/dev" | grep -G "^sd"); do disks_array+=("$i"); done

for i in "${disks_array[@]}" 
 do 
 echo "Trying /dev/$i" 
 if [ -b "/dev/mapper/$i"_cry ]
  then
    echo "/dev/mapper/$i"_cry exists.
 else 
   
 echo $pass | sudo cryptsetup --test-passphrase -T 1 --type tcrypt open "/dev/$i" "$i"_cry 
 if  [ $? -eq 0 ] 
  then
  echo "There is a key available with this passphrase. Mounting..." 
  echo $pass | sudo cryptsetup  --type tcrypt open "/dev/$i" "$i"_cry && \
  sudo mkdir -p /media/$user_/"$i"_cry 
  sudo mount -o uid=1000 /dev/mapper/"$i"_cry /media/$user_/"$i"_cry 
 fi
 echo
 
 fi
  done

}

unmount_ () {
#umount all
sudo echo 
declare -a disks_array
for i in $(ls "/dev" | grep -G "^sd"); do disks_array+=("$i"); done

for i in "${disks_array[@]}" 
 do 
 echo "Trying to unmount /dev/$i" 
 if [ -b "/dev/mapper/$i"_cry ]
  then
    echo "/dev/mapper/$i"_cry exists.
    sudo umount /media/$user_/"$i"_cry 
    sudo cryptsetup close "$i"_cry
 fi
done
}






if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit
fi

if  [ $1 == "m" ] 
  then
  mount_
  exit

fi

if  [ $1 == "u" ] 
  then
  unmount_ 
  exit

fi
echo "Unknown parameter"
exit
