# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# My aliases----------------------------------------------------------------------------------------------------------------

#Apps
alias tg680='/opt/telegram/telegram -many -workdir  /media/NTRCD/MYDOCS/ALL/local/all/tdata/680  >/dev/null 2>&1 &
disown $!'

alias tg9487='/opt/telegram/telegram -many -workdir /media/NTRCD/MYDOCS/ALL/local/all/tdata/94870   >/dev/null 2>&1 & 
disown $!'

alias joplin='cd "/media/NTRCD/MYDOCS/ALL/local/all/.joplin" && ./Joplin.AppImage.sh   >/dev/null 2>&1 & 
disown $!'

alias trill='export TRILIUM_DATA_DIR='/media/NTRCD/MYDOCS/ALL/local/all/triliumdata' && trilium >/dev/null 2>&1 & 
disown $!'

alias fprof1='firefox -start-debugger-server --profile "/media/NTRCD/MYDOCS/ALL/local/all/FirefoxProfile"   >/dev/null 2>&1 & 
disown $!'

alias thunder='thunderbird -profile "/media/NTRCD/MYDOCS/ALL/local/all/thunderbird/.thunderbird/sa4o6cv0.default"   >/dev/null 2>&1 &
disown $!'


#ffmpeg
makegif () {
  echo "makegif <file to convert> <skip in sec> <duration in sec> <scale in pix> <crop=out_w:out_h:x:y,>"
  echo 
  skipto=${2:-0}
  duration=${3:-5}
  scale=${4:-200}
  crop=${5:-""}
  ffmpeg -ss $skipto -t $duration -i "$1" -vf "$crop fps=10,scale=$scale:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$1.gif"

}

makemp3 () {
  echo "makemp3 <picture file to convert> <soundtrack file>"
  echo
ffmpeg -loop 1 -i "$1" -i "$2" -shortest -acodec copy  -vf fps=1 $1".mp4" 

}


makemp4 () {

if [ -z "$1" ]
then
  echo "makemp4 <file to convert> <bitrate (e.g. 1M,2000k)>  <scale>"
  echo 
  return 1
fi  

scale=""
if ! [ -z "$3" ]
then
      scale=",scale=$3:-1"
fi  

  
ffmpeg   -i "$1"    -c:v h264_nvenc  -b:v $2 -maxrate $2 -bufsize $2 -vf  "yadif$scale"  "$1.mp4"
}


#simple video grabber
sgrab () {

if [ -z "$1" ] || [ -z "$2"]
then
  echo "grabv <URL> <ext e.g. mp4> "
  echo 
  return 1
fi  


 wget --no-check-certificate $(curl "$1"  | grep -oP "http.*.$2\b"  | head -n 1)


}



cutvid () {

if [ -z "$1" ]
then
  echo "cutvid <file to convert> <start time e.g. 11:00>  <duration e.g. 25:00>"
  echo 
  return 1
fi  


  
ffmpeg -ss $2 -i "$1"   -t $3 -c copy "$1_cut_${2/:/_}.${1##*.}"
  
  
}

makesongwithpic () {

if [ -z "$1" ] || [ -z "$2"]
then
  echo "makesongwithpic <music file to convert> <pic file to add>"
  echo 
  return 1
fi  

ffmpeg -loop 1 -y -i "$2" -i "$1"  -shortest -acodec copy -vcodec mjpeg "$1".mp4

}


alias scrs='gnome-screenshot -a -c'

#Luks related
crym(){
image=NTRCD
part=sda4






if [ -b "/dev/mapper/$image" ]; then
    echo "/dev/mapper/$image exists."
    exit
fi
#mount partition 
sudo mkdir -p /media/$USER/$part
sudo mount -o uid=1000 /dev/$part /media/$USER/$part

#find and mount container
pathto=$(find -L /media/$USER/ -type f -name $image )
sudo mkdir -p /media/$image
sudo cryptsetup --type tcrypt open $pathto $image   && \
sudo mount -o uid=1000 /dev/mapper/$image /media/$image
}



moall(){

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


umoall(){

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
 else
    echo "No mounted volumes found." ; echo 
 fi
done

}


#-------------------------------------------------------------------------------

rmdup(){

if [[ -d "$1" ]]; then
    find "$1" -type f -exec md5sum {} + | sort | awk 'BEGIN{lasthash = ""} $1 == lasthash {print $0} {lasthash = $1}' |  cut -c35- | sed "s/.*/"\""&"\""/" | xargs rm
    find "$1" -type d -empty -print| xargs -r rm -r 
else
    echo "Removes duplicate files and empty dirs. Use rmdup <directory>"
    
fi

}



mountoffset(){


if [ -z "$1" ]
then
      echo "mountoffset pathtoimage offset (in sectors)"
      return 1
fi

if [ ! -f  "$1" ]; then
    echo "Image file not found!"
    return 2
fi


if [ -z "$2" ]
then
      offset=0
else  
      offset=$2
fi


FILE=$1
FILENAME=${FILE##*/}
sudo echo Partitions on image "$1" :
echo
echo
sudo fdisk -lu "$1"
echo
echo

echo Trying to mount image  "'$FILENAME'" ...
echo
echo

mod=$(echo "$FILENAME" | sed -r 's/[ ;:.-=\$\#\@\$\&\*\(\)+~\%]+/_/g' )
sudo mkdir -p "/media/$mod"
sudo  mount   -o rw,loop,offset=$(($offset*512)),umask=0000  "$1"  "/media/$mod" && echo "Mounted to /media/$mod"



}



#system
alias pcoff='systemctl shutdown'
alias susp='systemctl suspend'
alias hibern='systemctl hibernate'
alias edtor='sudo nano /etc/tor/torrc'

#archiver
c7z(){

if [ -z "$1" ]
then
  echo "c7z <file or folder to compress> <password [optional]>"
  echo 
  return 1
fi  


if [ -z "$2" ]
then
  pass=""
else 
  pass=-p"$2"
fi  

7z a $pass "$1".7z  "$1"

 
}


d7z(){

if [ -z "$1" ]
then
  echo "c7z <file or folder to decompress> <password [optional]>"
  echo 
  return 1
fi  


if [ -z "$2" ]
then
  pass=""
else 
  pass=-p"$2"
fi  

mkdir -p "$(dirname "${1}")/$(basename "${1}")_decompressed"

7z x $pass "$1"  -o"$(dirname "${1}")/$(basename "${1}")_decompressed"

 
}

#youtubdl
addv(){
echo "$*">> /media/NTRCD/MYDOCS/ALL/local/all/ytdl/video.txt
}

addf(){
echo "$*">> /media/NTRCD/MYDOCS/ALL/local/all/ytdl/files.txt
}

ytdlr(){
cd /media/NTRCD/MYDOCS/ALL/local/all/ytdl && python3 yb.py $1
}



alias addvn='echo Listening for links on 9000...&&nc -lp 9000 >> /media/NTRCD/MYDOCS/ALL/local/all/ytdl/video.txt'
alias updyoutdl='sudo wget -O /usr/bin/youtube-dl https://yt-dl.org/downloads/latest/youtube-dl ; sudo chmod 755 /usr/bin/youtube-dl;sudo cp /usr/bin/youtube-dl /usr/local/bin/youtube-dl; sudo chmod 755  /usr/local/bin/youtube-dl; sudo cp /usr/bin/youtube-dl /home/sergei/.local/bin/youtube-dl; sudo chmod 755 /home/sergei/.local/bin/youtube-dl'


# WINEPREFIX=/home/sergei/.local/share/wineprefixes/prefix32 WINEARCH=win32 wine /media/veracrypt1/MYDOCS/ALL/MCom/cstexloc/EssentialPIMPort4/startessentialpimport.exe
alias graphics='sudo system76-power help && sudo system76-power graphics'
alias graphicshyb='sudo system76-power graphics hybrid'
alias graphicsint='sudo system76-power graphics integrated'
alias graphicsnvd='sudo system76-power graphics nvidia'
alias graphicscom='sudo system76-power graphics compute'
#Runs an app when pc in hybrid gpu mode
alias graphicsvul='__NV_PRIME_RENDER_OFFLOAD=1 $1'
alias graphicsglx='__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia $1'

notab(){
echo $* >> /media/NTRCD/MYDOCS/DESKTOP/NOTES.txt
}

shut (){
sudo kill -9 $(pgrep $1)
}


# git 
gitpushdir(){

if [ -z "$1" ]
then
      echo "gitpushdir <dir>"
      return 1
fi

git config --global credential.helper cache
git -C "$1" commit -am "changed something"&&git -C "$1" push




}

function highlight() {
	declare -A fg_color_map
	fg_color_map[black]=30
	fg_color_map[red]=31
	fg_color_map[green]=32
	fg_color_map[yellow]=33
	fg_color_map[blue]=34
	fg_color_map[magenta]=35
	fg_color_map[cyan]=36
	 
	fg_c=$(echo -e "\e[1;${fg_color_map[$1]}m")
	c_rs=$'\e[0m'
	sed -u s"/$2/$fg_c\0$c_rs/g"
}

#save sorted bash history 


savehist(){

exclw='!/addv|addf|ytdlr|setdir1|tg680|firefox|thunder|fprof1|crontab|reboot|joplin|htop|gedit/'
tmpf=~/bashhistory.txt.tmp
hisf=~/historybk.txt
history | awk $exclw| awk '{print substr($0,6)}' | sort | uniq   >> $hisf && cat $hisf | sort | uniq   > $tmpf && mv $tmpf $hisf     



}

# Set the title string at the top of your current terminal window or terminal window tab
set-title() {
    # If the length of string stored in variable `PS1_BAK` is zero...
    # - See `man test` to know that `-z` means "the length of STRING is zero"
    if [[ -z "$PS1_BAK" ]]; then
        # Back up your current Bash Prompt String 1 (`PS1`) into a global backup variable `PS1_BAK`
        PS1_BAK=$PS1 
    fi

    # Set the title escape sequence string with this format: `\[\e]2;new title\a\]`
    # - See: https://wiki.archlinux.org/index.php/Bash/Prompt_customization#Customizing_the_terminal_window_title
    TITLE="\[\e]2;$@\a\]"
    # Now append the escaped title string to the end of your original `PS1` string (`PS1_BAK`), and set your
    # new `PS1` string to this new value
    PS1=${PS1_BAK}${TITLE}
}


#ACPI

#Temp 

tempcheck(){
if [[ $(cat /sys/class/thermal/thermal_zone*/temp | awk 'NR == 1' |awk '{ printf "%.0f" ,$1/1000}') -gt 75 ]]; then paplay '/home/sergei/mysounds/temp_is_above75.ogg' ;fi
}


#Memory

memorycheck(){
if [[ $(cat /proc/meminfo | grep MemAvailable | awk '{ printf "%.0f" ,$2/1024 }') -lt 3000 ]]
then 
#if out of memory and oomkiller did not the job
  kill -3 $(ps -eo pmem,vsize,pid,cmd | sort -k 1 -nr | head -1 |awk '{print $3}')
  paplay '/home/sergei/mysounds/memorylowcloseapp.ogg'
fi
}


wakemeup(){

echo 'Date:'
echo $(date)
echo
if [ -z "$1" ]
then
      echo "use: wakemeup  2020-02-28 15:00 or  wakemeup  15:00 "
      return 1
fi


sudo rtcwake -m show
sudo rtcwake -m no --date $1  
sudo rtcwake -m show

}


sleepat(){
echo 'Date:'
echo $(date)
echo
if [ -z "$1" ]
then
echo 'use: '
echo 'sleepat <"2:30 PM 10/21/2014">'
echo 'sleepat <"2:30 PM 21.10.14">'
echo 'sleepat <"now + 30 minutes">'
echo 'sleepat <"now + 1 hour">'
echo
return 1
fi

echo 'systemctl suspend'  | sudo at "$1"
echo 
echo 'Jobs:'
sudo atq 
}

alias wtemp='set-title "sensors"  && watch sensors'




searchist () {

if [ -z "$1" ]
then
      echo "searchist <keyword>"
      return 1
fi

cat ~/historybk.txt  | egrep -e "$1"

}  

#Shell
#Gnome wallpaper changer
set-wallpaper () {
uri=$(gsettings get org.gnome.desktop.background picture-uri)  


ls "$1/"*.{jpg,jpeg,png,bmp} |sort -R |while read i; 
 do
  if [ "$uri" != "'file://$i'" ]; then
    echo Setting new wallpaper "file://$i"
    gsettings set org.gnome.desktop.background picture-uri  "file://$i" ;
    break

  fi   
done

}

alias setdir2='echo Setting dirs-2...  
xdg-user-dirs-update --set DESKTOP "/media/NTRCD/MYDOCS/DESKTOP" 
xdg-user-dirs-update --set DOWNLOAD "/media/NTRCD/MYDOCS/Downloads" 
#;xdg-user-dirs-update --set DOCUMENTS "$HOME/Documents" \
#;xdg-user-dirs-update --set MUSIC "$HOME/Music" \
xdg-user-dirs-update --set PICTURES "/media/NTRCD/MYDOCS/Pictures" 
#;xdg-user-dirs-update --set VIDEOS "$HOME/Videos" \
nautilus -q 
killall -3 gnome-shell 
'


alias setdir1='echo Setting dirs-1...  
xdg-user-dirs-update --set DESKTOP "$HOME/Desktop" 
xdg-user-dirs-update --set DOWNLOAD "$HOME/Downloads" 
#;xdg-user-dirs-update --set DOCUMENTS "$HOME/Documents" \
#;xdg-user-dirs-update --set MUSIC "$HOME/Music" \
xdg-user-dirs-update --set PICTURES "$HOME/Pictures"
#;xdg-user-dirs-update --set VIDEOS "$HOME/Videos" \
nautilus -q 
killall -3 gnome-shell 
'

#weather
weather(){
dumpp=$(w3m -dump_source   'https://www.gismeteo.ru/weather-samarkand-5350/now/' ) && humid=$(echo "$dumpp" | grep -Po 'nowinfo__value\">[[:digit:]][[:digit:]]<\/div><div class=\"nowinfo__measure\">%<' | tr -dc '0-9') && temp=$(echo $dumpp | grep -Po 'nowvalue__sign\"\>[&|+|-].{55}' | sed  s/plus/+/g | tr -dc '0-9|\-,+') && notify-send Weather "Overboard temperature: $temp celsius and Humidity: $humid %"
}
#dpkg-query -L tor | grep torrc
#--------------------------------------------------------------------------------------------------








# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
