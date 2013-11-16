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
export LS_COLORS='bd=44;37:ca=30;41:cd=44;37:di=32:do=01;35:ex=35:fi=0:ln=36:mh=00:no=0:or=40;31;01:ow=34;42:pi=40;33:rs=0:sg=30;43:so=33:st=37;44:su=37;41:tw=30;42:*.7z=31:*.Z=31:*.aac=00;36:*.ace=31:*.anx=01;35:*.arj=31:*.asf=01;35:*.au=00;36:*.avi=01;35:*.axa=00;36:*.axv=01;35:*.bmp=01;35:*.bz2=31:*.bz=31:*.cgm=01;35:*.cpio=31:*.deb=31:*.dl=01;35:*.dz=31:*.ear=31:*.emf=01;35:*.flac=00;36:*.flc=01;35:*.fli=01;35:*.flv=01;35:*.gif=01;35:*.gl=01;35:*.gz=31:*.jar=31:*.jpeg=01;35:*.jpg=01;35:*.lz=31:*.lzh=31:*.lzma=31:*.m2v=01;35:*.m4v=01;35:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mkv=01;35:*.mng=01;35:*.mov=01;35:*.mp3=00;36:*.mp4=01;35:*.mp4v=01;35:*.mpc=00;36:*.mpeg=01;35:*.mpg=01;35:*.nuv=01;35:*.oga=00;36:*.ogg=00;36:*.ogm=01;35:*.ogv=01;35:*.ogx=01;35:*.pbm=01;35:*.pcx=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.qt=01;35:*.ra=00;36:*.rar=31:*.rm=01;35:*.rmvb=01;35:*.rpm=31:*.rz=31:*.sar=31:*.spx=00;36:*.svg=01;35:*.svgz=01;35:*.tar=31:*.taz=31:*.tbz2=31:*.tbz=31:*.tga=01;35:*.tgz=31:*.tif=01;35:*.tiff=01;35:*.tlz=31:*.txz=31:*.tz=31:*.vob=01;35:*.war=31:*.wav=00;36:*.webm=01;35:*.wmv=01;35:*.xbm=01;35:*.xcf=01;35:*.xpm=01;35:*.xspf=00;36:*.xwd=01;35:*.xz=31:*.yuv=01;35:*.z=31:*.zip=31:*.zoo=31'

export IRCSERVER="irc.homelien.no"

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=1048576
export HISTFILESIZE=1048576
#export PROMPT_COMMAND="history -a; history -c; history -r"
export SVN=http://dev01/repository
export IRCSERVER="irc.homelien.no"
export JDK_HOME="$JAVA_HOME"
export ORACLE_HOME=~/oracle/ora_home
export MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=256m"
export JBOSS_HOME=~/jboss/jboss
export TD_SRC_HOME=~/src/td
export TD_TRUNK_SRC_HOME=$TD_SRC_HOME/trunk
export DEPLOY=$TD_SRC_HOME/td_deploy
export HERCULES_HOME=$TD_SRC_HOME/deploy/hercules
export HERCULES_DEPLOY_ROOT=$TD_SRC_HOME/deploy/hercules/dist
export HERCULES_HTTP_TEST_TEMP=/tmp/hercules_http_test
export HERCULES_SRC_HOME="$TD_SRC_HOME/hercules"
export HERCULES_MODULES_SRC_HOME="$TD_SRC_HOME/hercules-modules"
export TC_SRC_HOME="$HOME/src/cgm/tc-next"
export TC_UNIX=1
export HISTTIMEFORMAT="%F %T "
#JUNIT_HOME="/usr/local/java/junit"
#CLASSPATH="$CLASSPATH:$JUNIT_HOME/junit.jar:/$JUNIT_HOME"
#MANPATH="$MANPATH:/usr/local/java/j2sdk/man"
export GTAGSLIBPATH="$HERCULES_SRC_HOME:$HERCULES_MODULES_SRC_HOME:$TD_TRUNK_SRC_HOME"

export KRED_POLL=true
export DIALYZER_PLT=$HOME/src/OTP/install/R15B03-1/dialyzer.plt

export OS_ID=$(source /etc/os-release ; echo $ID)

case $OS_ID in
    arch)
        export LESSOPEN="| source-highlight-esc.sh %s"
        ;;
    debian|linuxmint)
        export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh  %s"
        ;;
esac
export LESS=' -R '
