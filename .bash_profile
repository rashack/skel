# .bash_profile
echo "Reading .bash_profile"

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

export ANDROID_SDK_ROOT=~/android/android-sdk-linux
ANDROID_TOOLS=$ANDROID_SDK_ROOT/tools
ANDROID_PLATFORM_TOOLS=$ANDROID_SDK_ROOT/platform-tools
ANDROID_PATH=$ANDROID_PLATFORM_TOOLS:$ANDROID_TOOLS

export MUSIC_ROOT=/mnt/music
export EDITOR=vim
export JAVA_HOME=$HOME/jdk/jdk
export JDK_HOME=$JAVA_HOME
export SCALA_HOME=$HOME/scala/scala
export SBT_HOME=$HOME/sbt/sbt

BIN_PATH=$HOME/bin
JAVA_PATH=$JAVA_HOME/bin
SCALA_PATH=$SCALA_HOME/bin:$SBT_HOME/bin
ERLANG_PATH=~/src/OTP/install/R15B03-1/bin
export PATH=$BIN_PATH:$ERLANG_PATH:$JAVA_PATH:$ANDROID_PATH:$SCALA_PATH:$PATH
export ENV=$HOME/.bashrc

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

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=1048576
export HISTFILESIZE=1048576
#export PROMPT_COMMAND="history -a; history -c; history -r"
export ORACLE_HOME=~/oracle/ora_home
export HISTTIMEFORMAT="%F %T "
#JUNIT_HOME="/usr/local/java/junit"
#CLASSPATH="$CLASSPATH:$JUNIT_HOME/junit.jar:/$JUNIT_HOME"
#MANPATH="$MANPATH:/usr/local/java/j2sdk/man"

export KRED_POLL=true
export DIALYZER_PLT=$HOME/src/OTP/install/R15B03-1/dialyzer.plt
