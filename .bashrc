# .bashrc
#echo "Reading .bashrc"

export HOME_FQDN=rashack.dyndns.org

# User specific aliases and functions

MY_FONT="-misc-fixed-medium-r-semicondensed-*-13-120-75-75-c-60-iso8859-*"

#WINDOW_MANAGER=sawfish

alias ls='ls --color -F'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias gcc='gcc -ansi -Wall -pedantic -g'
alias ee='eeyes'
alias ec='emacsclient --alternate-editor="" -c'
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
umask 022
alias evince='dbus-launch --exit-with-session evince'

ulimit -n 2048
ulimit -c unlimited

export LC_COLLATE=POSIX
export LC_TIME=en_DK.utf8

if [[ $TERM =~ "xterm" ]]; then
    TERM="xterm-256color"
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
source ~/.skel/git-completion.bash
source ~/.skel/git-prompt.sh
# set_prompt is "not working" in the sense that it doesn't change the color of the prompt
# depending on the username
function set_prompt
{
    case $TERM in
 	xterm*)
	    TITLEBAR='\[\033]0;\w\007\]'
            ;;
	screen)
#	    TITLEBAR='\[\033k^fg(grey)[^fg(white)\u^fg(grey)@^fg(white)\h^fg(grey)] ^fg(green)\w^fg(white)\033\\\]'
	    TITLEBAR='\[\033k\h \w\033\\\]'
	    ;;
 	*)
            local TITLEBAR=''
            ;;
    esac

    export PS1=${TITLEBAR}'\
\[\033[31m\][\t] \
\[\033[m\]\[\033[44m\][\u@\h]\
\[\033[40m\]\[\033[32m\] \w\
\[\033[33m\]`__git_ps1 "(%s)"`\[\033[m\]\$ '
}

if [ "$USER" == 'root' ]; then
    set_prompt '\033[41m\]'
else
    set_prompt '\033[44m\]'
fi

shopt -s checkwinsize

# ORIG_PS1=$PS1
# SGR0=$(tput sgr0)
# FR=$(tput setaf 1)
# FG=$(tput setaf 2)
# FY=$(tput setaf 3)
# BB=$(tput setab 4)
# TPUT_PS1=\
# $FR'[\t] '\
# $SGR0$BB'[\u@\h]'\
# $SGR0$FG' \w'\
# $FY'`__git_ps1 "(%s)"`'\
# $(if [ $? == 0 ] ; then echo -ne "$SGR0" ; else echo -ne "$FR" ; fi)'\$'\
# $SGR0' '

# Set the title of a Terminal window
function settitle {
    if [ -n "$STY" ] ; then         # We are in a screen session
	echo "Setting screen titles to $@"
	printf "\033k%s\033\\" "$@"
	screen -X eval "at \\# title $@" "shelltitle $@"
    else
	printf "\033]0;%s\007" "$@"
    fi
}

SSH_AGENT_ENV=$HOME/.ssh/agent-environment
function start-ssh-agent {
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > $SSH_AGENT_ENV
    chmod 600 $SSH_AGENT_ENV
    source $SSH_AGENT_ENV > /dev/null
}

if [ -f $SSH_AGENT_ENV ] ; then
    source $SSH_AGENT_ENV > /dev/null
    ps $SSH_AGENT_PID | grep -q ssh-agent || {
	start-ssh-agent
    }
else
    start-ssh-agent
fi
