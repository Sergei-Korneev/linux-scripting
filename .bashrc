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
  ffmpeg -ss $skipto -t $duration -i $1  -vf "$crop fps=10,scale=$scale:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 $1.gif

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


alias edittor='sudo nano /etc/tor/torrc'

#youtubdl
addv(){
echo $*>> /media/NTRCD/MYDOCS/ALL/local/all/ytdl/video.txt
}

addf(){
echo $*>> /media/NTRCD/MYDOCS/ALL/local/all/ytdl/files.txt
}

ytdlr(){
cd /media/NTRCD/MYDOCS/ALL/local/all/ytdl && python3 yb.py $1
}



alias addvn='echo Listening for links on 9000...&&nc -lp 9000 >> /media/NTRCD/MYDOCS/ALL/local/all/ytdl/video.txt'
alias updyoutdl='sudo wget -O /usr/bin/youtube-dl https://yt-dl.org/downloads/latest/youtube-dl && sudo chmod 755 /usr/bin/youtube-dl'


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

alias setdir2='echo Setting dirs-2...  
xdg-user-dirs-update --set DESKTOP "/media/NTRCD/MYDOCS/DESKTOP" 
xdg-user-dirs-update --set DOWNLOAD "/media/NTRCD/MYDOCS/Downloads" 
#;xdg-user-dirs-update --set DOCUMENTS "$HOME/Documents" \
#;xdg-user-dirs-update --set MUSIC "$HOME/Music" \
#;xdg-user-dirs-update --set PICTURES "$HOME/Pictures" \
#;xdg-user-dirs-update --set VIDEOS "$HOME/Videos" \
nautilus -q 
killall -3 gnome-shell 
'


alias setdir1='echo Setting dirs-1...  
xdg-user-dirs-update --set DESKTOP "$HOME/Desktop" 
xdg-user-dirs-update --set DOWNLOAD "$HOME/Downloads" 
#;xdg-user-dirs-update --set DOCUMENTS "$HOME/Documents" \
#;xdg-user-dirs-update --set MUSIC "$HOME/Music" \
#;xdg-user-dirs-update --set PICTURES "$HOME/Pictures" \
#;xdg-user-dirs-update --set VIDEOS "$HOME/Videos" \
nautilus -q 
killall -3 gnome-shell 
'



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
