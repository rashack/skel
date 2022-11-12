export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_COLLATE=POSIX
export LC_TIME=en_DK.utf8

export REPORTTIME=1

LS_COLORS="bd=44;37:ca=30;41:cd=44;37:di=32:ex=35:fi=0:ln=36:mh=00:no=0:\
or=40;31;01:ow=34;42:pi=40;33:rs=0:sg=30;43:so=33:st=37;44:su=37;41:tw=30;42:"
LS_C_ARCHIVES="*.7z=31:*.Z=31:*.ace=31:*.arj=31:*.bz2=31:*.bz=31:*.cpio=31:\
*.deb=31:*.dz=31:*.ear=31:*.gz=31:*.jar=31:*.lz=31:*.lzh=31:*.lzma=31:*.rar=31:\
*.rpm=31:*.rz=31:*.sar=31:*.tar=31:*.taz=31:*.tbz2=31:*.tbz=31:*.tgz=31:\
*.tlz=31:*.txz=31:*.tz=31:*.war=31:*.xz=31:*.z=31:*.zip=31:*.zoo=31:"
LS_C_AUD="*.aac=00;36:*.au=00;36:*.axa=00;36:*.flac=00;36:*.mid=00;36:\
*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.oga=00;36:*.ogg=00;36:\
*.ra=00;36:*.spx=00;36:*.wav=00;36:*.xspf=00;36:"
LS_C_IMG="do=35:*.anx=35:*.asf=35:*.avi=35:*.axv=35:*.bmp=35:*.cgm=35:*.dl=35:\
*.flv=35:*.m4v=35:*.pcx=35:*.ppm=35:*.emf=35:*.flc=35:*.fli=35:*.gif=35:\
*.gl=35:*.jpeg=35:*.jpg=35:*.m2v=35:*.mkv=35:*.mng=35:*.mov=35:*.mp4=35:\
*.mp4v=35:*.mpeg=35:*.mpg=35:*.nuv=35:*.ogm=35:*.ogv=35:*.ogx=35:*.pbm=35:\
*.pgm=35:*.png=35:*.qt=35:*.rm=35:*.rmvb=35:*.svg=35:*.svgz=35:*.tga=35:\
*.tif=35:*.tiff=35:*.vob=35:*.webm=35:*.wmv=35:*.xbm=35:*.xcf=35:*.xpm=35:\
*.xwd=35:*.yuv=35:"
LS_C_EXTRA=$LS_C_ARCHIVES$LS_C_AUD$LS_C_IMG
export LS_COLORS=$LS_COLORS${LS_C_EXTRA// /}

export RIPGREP_CONFIG_PATH=~/.ripgreprc

export SAVEHIST=100000

# don't remove the space before | and & after a tab completion
export ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;'

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$PATH

autoload -U select-word-style
select-word-style bash
setopt globdots

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="kjellz"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    docker
    git
    pass
)
#    zsh-syntax-highlighting
#)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias ls='gls -F --color=tty'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias hd='hexdump -C'
alias bc='bc -l'
alias more='less -FX'
LESSPIPE=`which src-hilite-lesspipe.sh`
export LESSOPEN="| ${LESSPIPE} %s"
export LESS=' -R -X -F '
alias diff='colordiff -u'
alias wdiff='wdiff -w "$(tput setaf 1)" -x "$(tput sgr0)" -y "$(tput setaf 2)" -z "$(tput sgr0)"'
alias passs='PASSWORD_STORE_ENABLE_EXTENSIONS=true pass pass-fzf'
alias rg="rg --hidden --glob '!.git'"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kjell/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kjell/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kjell/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kjell/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -f "/Users/kjell/.ghcup/env" ] && source "/Users/kjell/.ghcup/env" # ghcup-env


# function preexec() {
#   timer=$(($(date +%s%0N)/1000000))
# }

# function precmd() {
#   if [ $timer ]; then
#     now=$(($(date +%s%0N)/1000000))
#     elapsed=$(($now-$timer))

#     export RPROMPT="%F{cyan}${elapsed}ms %{$reset_color%}"
#     unset timer
#   fi
# }

# function preexec() {
#     timer=${timer:-$SECONDS}
# }

# function precmd() {
#     if [ $timer ]; then
#         timer_show=$(($SECONDS - $timer))
#         timer_show=$(printf '%.*f\n' 3 $timer_show)
#         export RPROMPT="[%F{$cyan}%?%F{$red}] : %F{cyan}${timer_show}s %{$reset_color%}"
#         unset timer
#     fi
# }

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/Users/kjell/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/Users/kjell/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/Users/kjell/miniconda3/etc/profile.d/conda.sh"
#    else
        export PATH="/Users/kjell/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/opt/homebrew/opt/ed/bin:/opt/homebrew/opt/ed/libexec/gnubin:/opt/homebrew/opt/findutils/libexec/gnubin:/opt/homebrew/opt/gnu-tar/libexec/gnubin:/opt/homebrew/opt/grep/libexec/gnubin:/opt/homebrew/opt/make/libexec/gnubin:$PATH"
fi

ulimit -n 10240
