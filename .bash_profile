# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

ANDROID_SDK_ROOT=/home/kjell/android/android-sdk-linux

export EDITOR=vim
export JAVA_HOME=$HOME/java/jdk
export JDK_HOME=$JAVA_HOME
export CATALINA_HOME=/mnt/raid/kjell/apache-tomcat
export PATH=$HOME/bin:$JAVA_HOME/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH
export ENV=$HOME/.bashrc
#USERNAME=""
export HISTSIZE=1048576
export LS_COLORS='no=0:fi=0:di=32:ln=36:pi=31:so=33:bd=44;37:cd=44;37:ex=35'
export IRCNICK="Rashack"
#IRCNAME="c"
#IRCUSER="rot"
export IRCSERVER="irc.homelien.no"
#JUNIT_HOME="/usr/local/java/junit"
#CLASSPATH="$CLASSPATH:$JUNIT_HOME/junit.jar:/$JUNIT_HOME"
#MANPATH="$MANPATH:/usr/local/java/j2sdk/man"

# if [ $USER = 'root' ]; then
#     PS1='\[\033[41m\][\u@\h]\[\033[40m\] \W\$ '
# else

# PS1='\[\033[31m\][\t] \[\033[m\]\[\033[44m\][\u@\h]\[\033[40m\[\033[32m\] \W\[\033[m\]\$ '

# #    PS1='\[\033[44m\][\u@\h]\[\033[40m\] \W\$ '
# fi

export PS1
