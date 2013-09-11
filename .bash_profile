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

export EDITOR=vim
export JAVA_HOME=$HOME/jdk/jdk
export SCALA_HOME=$HOME/scala/scala
export JDK_HOME=$JAVA_HOME
export PATH=$HOME/bin:$JAVA_HOME/bin:$ANDROID_PATH:$SCALA_HOME/bin:$PATH
export ENV=$HOME/.bashrc
export LS_COLORS='no=0:fi=0:di=32:ln=36:pi=31:so=33:bd=44;37:cd=44;37:ex=35'
export IRCSERVER="irc.homelien.no"

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=1048576
export HISTFILESIZE=1048576
#export PROMPT_COMMAND="history -a; history -c; history -r"
export SVN=http://dev01/repository

export LS_COLORS='no=0:fi=0:di=32:ln=36:pi=31:so=33:bd=44;37:cd=44;37:ex=35'
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
