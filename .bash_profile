# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

JAVA_HOME="~/java/jdk"
PATH="$JAVA_HOME/bin:$PATH:~/bin"
ENV=$HOME/.bashrc
#USERNAME=""
HISTSIZE=32768
LS_COLORS='no=0:fi=0:di=32:ln=36:pi=31:so=33:bd=44;37:cd=44;37:ex=35'
IRCNICK="Rashack"
#IRCNAME="c"
#IRCUSER="rot"
IRCSERVER="irc.homelien.no"
JDK_HOME="$JAVA_HOME"
#JUNIT_HOME="/usr/local/java/junit"
#CLASSPATH="$CLASSPATH:$JUNIT_HOME/junit.jar:/$JUNIT_HOME"
#MANPATH="$MANPATH:/usr/local/java/j2sdk/man"

# if [ $USER = 'root' ]; then
#     PS1='\[\033[41m\][\u@\h]\[\033[40m\] \W\$ '
# else

# PS1='\[\033[31m\][\t] \[\033[m\]\[\033[44m\][\u@\h]\[\033[40m\[\033[32m\] \W\[\033[m\]\$ '

# #    PS1='\[\033[44m\][\u@\h]\[\033[40m\] \W\$ '
# fi

export PATH ENV USERNAME HISTSIZE LS_COLORS PS1 IRCNICK IRCSERVER JAVA_HOME JDK_HOME
