# .bashrc

export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=1048576
export HISTFILESIZE=1048576

export OS_ID=$(source /etc/os-release ; echo $ID)
export HOME_FQDN=rashack.com

MY_FONT="-misc-fixed-medium-r-semicondensed-*-13-120-75-75-c-60-iso8859-*"

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls --color -F'
alias ltr='ls -ltr --time-style=+"%Y-%m-%d %H:%M:%S %a"'
alias more='less -FX'
alias gcc='gcc -ansi -Wall -pedantic -g'
alias ee='emacs -Q -nw'
alias em='emacsclient --alternate-editor="" -c'
alias nl='nl -ba'
alias od='od -Ax -t x1'
alias wcmencoder='mencoder tv:// -tv driver=v4l2:width=960:height=720:device=/dev/video0 -nosound -ovc lavc -o wcrecording.avi'
alias xscreensaver='xscreensaver -nosplash -display :0.0'
#alias snes9x='snes9x -joydev1 /dev/input/js0 -joymap1 13 14 12 15 10 11 3 0' # sixaxis
alias snes9x='snes9x -joydev /dev/js0 -joymap1 1 2 0 3 4 5 9 8' # ps2 (?)
alias sheet='xpdf -display :0.1 -z width -geometry 800x600'
alias cal='ncal -b'
alias bc='bc -l'
alias grep='grep --color'
alias pgrep='pgrep -l'
alias diff='colordiff -u'
umask 022
alias evince='dbus-launch --exit-with-session evince'
alias hideprev='history -d $((HISTCMD-2)) && history -d $((HISTCMD-1))'
alias ag='ag --noheading --color-path=35 --color-line-number=32 --color-match=31'
alias irb='rlwrap irb'

ulimit -n 2048
ulimit -c unlimited

# from eval $(dircolors -b)
# replaced   bd=40;33;01:cd=40;33;01:di=01;34:ex=01;32  :ln=01;36  :so=01;35:
# with these bd=44;37   :cd=44;37   :di=32   :ex=35:fi=0:ln=36:no=0:so=33:
LS_COLORS="bd=44;37:ca=30;41:cd=44;37:di=32:ex=35:fi=0:ln=36:mh=00:no=0:\
or=40;31;01:ow=34;42:pi=40;33:rs=0:sg=30;43:so=33:st=37;44:su=37;41:tw=30;42:"
LS_C_ARCHIVES=$(echo {*.7z,*.Z,*.ace,*.arj,*.bz2,*.bz,*.cpio,*.deb,*.dz,\
*.ear,*.gz,*.jar,*.lz,*.lzh,*.lzma,*.rar,*.rpm,*.rz,*.sar,*.tar,*.taz,*.tbz2,\
*.tbz,*.tgz,*.tlz,*.txz,*.tz,*.war,*.xz,*.z,*.zip,*.zoo}'=31:')
LS_C_AUD=$(echo {*.aac,*.au,*.axa,*.flac,*.mid,*.midi,*.mka,*.mp3,*.mpc,\
*.oga,*.ogg,*.ra,*.spx,*.wav,*.xspf}'=00;36:')
LS_C_IMG=$(echo {do,*.anx,*.asf,*.avi,*.axv,*.bmp,*.cgm,*.dl,*.flv,*.m4v,\
*.pcx,*.ppm,*.emf,*.flc,*.fli,*.gif,*.gl,*.jpeg,*.jpg,*.m2v,*.mkv,*.mng,\
*.mov,*.mp4,*.mp4v,*.mpeg,*.mpg,*.nuv,*.ogm,*.ogv,*.ogx,*.pbm,*.pgm,*.png,\
*.qt,*.rm,*.rmvb,*.svg,*.svgz,*.tga,*.tif,*.tiff,*.vob,*.webm,*.wmv,*.xbm,\
*.xcf,*.xpm,*.xwd,*.yuv}'=35:')
LS_C_EXTRA=$LS_C_ARCHIVES$LS_C_AUD$LS_C_IMG
export LS_COLORS=$LS_COLORS${LS_C_EXTRA// /}

export LC_COLLATE=POSIX
export LC_TIME=en_DK.utf8
export LANG=en_US.utf8

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
source ~/.skel/git-completion.bash
source ~/.skel/git-prompt.sh

__dark_bg() {
    $HOME/bin/xterm-bg-colour.sh | grep -q "rgb:0000/0000/0000"
}

__ucol() {
    __dark_bg && echo -e '\[\e[44m\]' || echo -e '\[\e[34m\]'
}

__prompt_time_colour() {
    __dark_bg && echo -n "37m"|| echo -n "m"
}

function __set_prompt
{
    local EXIT="$?"
    if [ "$SSH_CONNECTION" ]; then
        SSH_PROMPT='\[\e[m\] [\[\e[31m\]SSH\[\e[m\]] '
    else
        SSH_PROMPT=
    fi
    case $TERM in
 	xterm*)
	    TITLEBAR='\[\e]0;\w\007\]'
            ;;
	screen)
#	    TITLEBAR='\[\033k^fg(grey)[^fg(white)\u^fg(grey)@^fg(white)\h^fg(grey)] ^fg(green)\w^fg(white)\033\\\]'
	    TITLEBAR='\[\033k\h \w\033\\\]'
	    ;;
 	*)
            local TITLEBAR=''
            ;;
    esac

    local UCOL=$(__ucol)
    if [ "$USER" == 'root' ]; then
        UCOL='\[\e[41m\]'
    fi

    PS1=${TITLEBAR}
    if [ $EXIT != 0 ]; then
        PS1+=" \[\e[31m\]($EXIT)\[\e[0m\] "
    fi

    PS1+='\
\[\e['$(__prompt_time_colour)'\][\t] \
\[\e[m\]'$UCOL'[\u@\h]\
\[\e[m\] \[\e[32m\]\w\
\[\e[33m\]`__git_ps1 "(%s)"`'$SSH_PROMPT'\[\e[m\]\$ '
    history -a
}
export PROMPT_COMMAND=__set_prompt

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

export LESS_TERMCAP_so=$'\E[30;43m'
export LESS_TERMCAP_se=$'\E[0m'

# colorize man
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[30;43m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    man "$@"
}

alias gnp='git --no-pager'
alias gid='git diff'
__gdiff () {
    COMPREPLY=()
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local pgwd=$(realpath --relative-to=$(git rev-parse --show-toplevel) $(pwd))
    local opts
    for opt in $(git status --porcelain | grep '^.[^ ?]' | cut -b 4-) ; do
        opts="$opts $(realpath --relative-to=$PWD $(git rev-parse --show-toplevel)/$opt)"
    done
    case "${prev}" in
        gid)
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
            ;;
    esac
}
complete -F __gdiff gid

case $OS_ID in
    arch)
        export LESSOPEN="| source-highlight-esc.sh %s"
        ;;
    *) # Debian and derivatives
        export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh  %s"
        ;;
esac
export LESS=' -R '

hgrep () {
    local cmd="history "
    # build an awk program: '/pattern1/ && /pattern2/ && ...'
    local search=$(echo "$@" | sed "s/ /\/ \&\& \//g")
    # build a grep highlight pattern: '^|pattern1|pattern2|...'
    local highlight=$(echo "$@" | sed "s/ /|/g")
    history | awk "/$search/" | grep --color -E "^|$highlight"
}

export ANDROID_SDK_ROOT=~/android/sdk
ANDROID_TOOLS=$ANDROID_SDK_ROOT/tools
ANDROID_PLATFORM_TOOLS=$ANDROID_SDK_ROOT/platform-tools
ANDROID_PATH=$ANDROID_PLATFORM_TOOLS:$ANDROID_TOOLS

export ORIGINAL_SYSTEM_PATH=$PATH

function set_normal_homes() {
    export JAVA_HOME=$HOME/jdk/jdk
    export JDK_HOME=$JAVA_HOME
    export SCALA_HOME=$HOME/scala/scala
    export SBT_HOME=$HOME/sbt/sbt
}

function set_normal_path() {
    set_normal_homes
    export ERLANG_HOME=~/otp/install
    local BIN_PATH=$HOME/bin
    local ERLANG_PATH=$ERLANG_HOME/bin
    local JAVA_PATH=$JAVA_HOME/bin
    local SCALA_PATH=$SCALA_HOME/bin:$SBT_HOME/bin
    export PATH=$ORIGINAL_SYSTEM_PATH:$BIN_PATH:$ERLANG_PATH:$JAVA_PATH:$ANDROID_PATH:$SCALA_PATH
}

function set_non_erl_path() {
    set_normal_homes
    unset ERLANG_HOME
    local BIN_PATH=$HOME/bin
    local JAVA_PATH=$JAVA_HOME/bin
    local SCALA_PATH=$SCALA_HOME/bin:$SBT_HOME/bin
    export PATH=$ORIGINAL_SYSTEM_PATH:$BIN_PATH:$JAVA_PATH:$ANDROID_PATH:$SCALA_PATH
}

function set_java7_path() {
    export PATH=${PATH/$JAVA_HOME/$HOME/jdk/jdk7}
    export JAVA_HOME=$HOME/jdk/jdk7
    export JDK_HOME=$JAVA_HOME
}

function set_java8_path() {
    export PATH=${PATH/$JAVA_HOME/$HOME/jdk/jdk8}
    export JAVA_HOME=$HOME/jdk/jdk8
    export JDK_HOME=$JAVA_HOME
}

function set_non_java_path() {
    export PATH=${PATH/$JAVA_HOME/}
    unset JAVA_HOME
    unset JDK_HOME
}

set_normal_path

rbenv() {
  local command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "`rbenv "sh-$command" "$@"`";;
  *)
    command rbenv "$command" "$@";;
  esac
}

export GEM_HOME=~/.gem
export RBENV_SHELL=bash
export RBENV_PATH=$HOME/.rbenv
export RUBY_PATH=$RBENV_PATH/bin:$RBENV_PATH/shims:$RBENV_PATH/plugins/ruby-build/bin:$GEM_HOME/gems/bundler-1.10.6/bin
export PATH=$RUBY_PATH:$PATH
source ~/.rbenv/completions/rbenv.bash
rbenv rehash 2>/dev/null

source ~/.skel/lib/tmux-completion.bash

# path for Haskell Stack
export PATH=$HOME/.local/bin:$PATH
eval "$(stack --bash-completion-script stack)"
# path for Rust
export PATH="$PATH:$HOME/.cargo/bin"

source ~/.work-environment
source ~/src/kerl/bash_completion/kerl

export PATH="$PATH:$HOME/usr/local/bin"

bind -x '"\e\C-i":"git diff"'
bind -x '"\e\C-u":"git status"'
