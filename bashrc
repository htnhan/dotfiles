#!/bin/bash

# Don't do anything if we are not interactive
case $- in
    *i*) ;;
      *) return;;
esac

export COLOR_NC="\001$(tput sgr0)\002"
export COLOR_WHITE="\001$(tput bold; tput setaf 7)\002"
export COLOR_BLACK="\001$(tput setaf 0)\002"
export COLOR_BLUE="\001$(tput setaf 4)\002"
export COLOR_LIGHT_BLUE="\001$(tput bold; tput setaf 4)\002"
export COLOR_GREEN="\001$(tput setaf 2)\002"
export COLOR_LIGHT_GREEN="\001$(tput bold; tput setaf 2)\002"
export COLOR_CYAN="\001$(tput setaf 6)\002"
export COLOR_LIGHT_CYAN="\001$(tput bold; tput setaf 6)\002"
export COLOR_RED="\001$(tput setaf 1)\002"
export COLOR_LIGHT_RED="\001$(tput bold; tput setaf 1)\002"
export COLOR_PURPLE="\001$(tput setaf 5)\002"
export COLOR_LIGHT_PURPLE="\001$(tput bold; tput setaf 5)\002"
export COLOR_BROWN="\001$(tput setaf 3)\002"
export COLOR_YELLOW="\001$(tput bold; tput setaf 3)\002"
export COLOR_GRAY="\001$(tput setaf 0)\002"
export COLOR_LIGHT_GRAY="\001$(tput bold; tput setaf 0)\002"

function pc {
    # Store old error code
    oldec=$?
    branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')
    if [ $? -eq 0 ]; then
        echo -ne "$COLOR_CYAN$branch$COLOR_NC"
    fi
    return $oldec
}

# dir colors
#LS_COLORS='rs=0:di=00;36:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
LS_COLORS='rs=0:di=00;36:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=00;36:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

export SVN_EDITOR="vim"
export GIT_EDITOR="vim"
export LANG=en_US.UTF-8

export PS1="\n$COLOR_GREEN\u$COLOR_NC@$COLOR_PURPLE\h $COLOR_BROWN\w\$(pc)\n\$(if [[ \$? == 0 ]]; then echo -ne \"$COLOR_GREEN\$?\"; else echo -ne \"$COLOR_RED\$?\"; fi)$COLOR_LIGHT_CYAN \$$COLOR_NC "

export PATH="$HOME/bin:$PATH"

# aliases
alias ls='ls -h --color'
alias vi='vim'
alias tmux='tmux -2'
alias grep='grep --color -n'
alias shred='shred -vuz -n 26'
alias rdp='rdesktop -g 1912x1060 -K -N -xal -P'

GREP=$(which grep)
function mgrep() {
    # markdown grep
    # needs pandoc (format converter) and lynx (CLI webbrowser
    # grep, then pandoc to go from md -> html, then lynx
    if [ $# -lt 1 ]; then
        echo "Usage: mgrep [args...]"
    else
        $GREP -i $@ |pandoc |lynx -stdin
    fi
}
