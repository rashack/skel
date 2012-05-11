# .bashrc

# User specific aliases and functions

MY_FONT="-misc-fixed-medium-r-semicondensed-*-13-120-75-75-c-60-iso8859-*"

#WINDOW_MANAGER=sawfish

alias ls='ls --color -F'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias gcc='gcc -ansi -Wall -pedantic -g'
alias ee='eeyes'
alias ec='emacsclient'
alias nl='nl -ba'
#alias emacs='emacs -fn $MY_FONT'
alias mmplayer='mplayer -monitoraspect 16:9 -stop-xscreensaver -display :0.1'
alias mmplayerac3='mplayer -ao alsa:device=spdif -ac hwac3 -monitoraspect 16:9 -stop-xscreensaver -display :0.1'
alias mmplayerdts='mplayer -ao alsa:device=spdif -ac hwdts -monitoraspect 16:9 -stop-xscreensaver -display :0.1'
alias mplayerac3='mplayer -ao alsa:device=spdif -ac hwac3'
alias mplayerdts='mplayer -ao alsa:device=spdif -ac hwdts'
alias wcmplayer='mplayer -fps 30 tv:// -tv driver=v4l2:device=/dev/video0'
alias wcmencoder='mencoder tv:// -tv driver=v4l2:width=960:height=720:device=/dev/video0 -nosound -ovc lavc -o wcrecording.avi'
alias xscreensaver='xscreensaver -nosplash -display :0.0'
#alias snes9x='snes9x -joydev1 /dev/input/js0 -joymap1 13 14 12 15 10 11 3 0' # sixaxis
alias snes9x='snes9x -joydev /dev/js0 -joymap1 1 2 0 3 4 5 9 8' # ps2 (?)
alias sheet='xpdf -display :0.1 -z width -geometry 800x600'
alias cal='cal -m'
alias bc='bc -l'
alias dzen2='dzen2 -fn "$MY_FONT"'
alias grep='grep --color'
alias pgrep='pgrep -l'
alias diff='colordiff -u'
umask 077

ulimit -n 2048
ulimit -c unlimited

export LC_COLLATE=POSIX

if [[ $TERM =~ "xterm" ]]; then
    TERM="xterm-256color"
fi

source ~/.git-completion.sh
# set_prompt is "not working" in the sense that it doesn't change the color of the prompt
# depending on the username
function set_prompt
{
    case $TERM in
 	xterm*)
	    TITLEBAR='\[\033]0;\w\007\]'
            ;;
 	*)
            local TITLEBAR=''
            ;;
    esac

    local GIT_BRANCH=git_branch
    export PS1=${TITLEBAR}'\
\[\033[31m\][\t] \
\[\033[m\]\[\033[44m\][\u@\h]\
\[\033[40m\]\[\033[32m\] \W\
\[\033[33m\]`__git_ps1 "(%s)"`\[\033[m\]\$ '
}

if [ $USER = 'root' ]; then
    set_prompt '\033[41m\]'
else
    set_prompt '\033[44m\]'
fi

shopt -s checkwinsize
