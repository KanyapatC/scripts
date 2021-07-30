PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
# User specific environment and startup programs

JAVA_HOME=/u01/java/jdk1.8.0_291
export JAVA_HOME
WLS_HOME=/u01/oracle/middleware/wls12214/user_projects/domains/base_domain
export WLS_HOME
PATH=$PATH:$ORACLE_HOME/bin:$WLS_HOME/bin
