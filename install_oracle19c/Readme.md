# Install Oracle Database 19c on CentOS 8

** Please use the `root` user to edit the files and execute the commands unless further notice. **

## Prerequisite

1. Download the latest [CentOS Stream 8](https://www.centos.org/download/).
2. After installing the CentOS, execute the following commands to get the required libraries to create applications for handling compiled objects.

```
dnf update
dnf -y install elfutils-libelf-devel
```
# Recommend separate disk mount path /u01 because we will create directory only

1. create directory under path /u01

```bash
mkdir /u01/app
mkdir /u01/app/oracle
mkdir /u01/app/oraInventory
mkdir /u01/setup
```
## Hostname and Host File

1. Open the file `/etc/hostname`, change the content to update the hostname.

```
localhost.localdomain
```

2. Open the file `/etc/hosts`, add your IP address and hostname.

```
<Your IP Address> localhost.localdomain
```
## Download Packages and Software in /u01/setup

```bash
cd /u01/setup
```
- [compat-libcap1-1.10-7.el7.x86_64.rpm](https://rpmfind.net/linux/rpm2html/search.php?query=compat-libcap1)
- [compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm](https://rpmfind.net/linux/rpm2html/search.php?query=compat-libstdc%2B%2B)
- [oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm](https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm)
- [LINUX.X64_193000_db_home.zip](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html)

## Install Required Packages

1. Perform a dnf update to update every currently installed package.

```bash
dnf update
```

2. Add execute permission to the downloaded rpm files.

```bash
cd /u01/setup 
chmod u+x *.rpm
```

3. Install the libcapl library for getting and setting POSIX.1e (formerly POSIX 6) draft 15 capabilities.

```bash
dnf localinstall -y compat-libcap1-1.10-7.el7.x86_64.rpm
```

4. Inatll the libstdc++ package which contains compatibility standard C++ library from GCC 3.3.4.

```bash
dnf localinstall -y compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm
```

5. Install the below required packages.

```bash
dnf install -y bc binutils elfutils-libelf elfutils-libelf-devel fontconfig-devel \
    gcc gcc-c++ glibc glibc-devel ksh ksh libaio libaio-devel libgcc libnsl libnsl.i686 \
    libnsl2 libnsl2.i686 librdmacm-devel libstdc++ libstdc++-devel libX11 libXau libxcb \
    libXi libXrender libXrender-devel libXtst make net-tools nfs-utils smartmontools \
    sysstat targetcli unixODBC;
```

## Install Oracle Installation Prerequisites

1. Install the Oracle Installation Prerequisites (OIP) package.

```bash
dnf localinstall -y oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm
```

2. Open the `/etc/group` file, update the GID of the below items.

```
oinstall:x:64890:oracle
dba:x:64891:oracle
oper:x:64892:oracle
backupdba:x:64893:oracle
dgdba:x:64894:oracle
kmdba:x:64895:oracle
racdba:x:64896:oracle
```

3. Open the `/etc/passwd` file, update both the UID and GID of account `oracle`.

```
oracle:x:64890:64890::/home/oracle:/bin/bash
```

4. Update the password of account `oracle`.

```bash
passwd oracle
```

5. Set secure Linux to permissive by editing the `/etc/selinux/config` file.

```bash
SELINUX=permissive
```

6. Set the secure Linux change right now.

```bash
setenforce Permissive
```

7. Open the firewall.

```bash
firewall-cmd --zone=public --permanent --add-port=1521/tcp
firewall-cmd --reload
```

## Setup Oracle User Profile

1. Create Oracle directories.

```bash
mkdir -p /u01/app/oracle/product/19.3.0/dbhome_1
mkdir -p /u01/oradata
chown -R oracle:oinstall /u01 
chmod -R 775 /u01 
```

2. Create a new directory for Oracle user.

```bash
mkdir -p /home/oracle/scripts
chown -R oracle:oinstall /home/oracle
```

3. Create an environment setting file.

```bash
cat > /home/oracle/scripts/setEnv.sh <<EOF
# Oracle Settings
export TMP=/tmp
export TMPDIR=\$TMP

export ORACLE_HOSTNAME=$HOSTNAME
export ORACLE_UNQNAME=orcl
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=\$ORACLE_BASE/product/19.3.0/dbhome_1
export ORA_INVENTORY=/u01/app/oraInventory
export ORACLE_SID=orcl
export PDB_NAME=pdb1
export DATA_DIR=/u01/oradata

export PATH=/usr/sbin:/usr/local/bin:\$PATH
export PATH=\$ORACLE_HOME/bin:\$PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib
EOF
```

4. Create a startup shell script.

```bash
cat > /home/oracle/scripts/start_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbstart \$ORACLE_HOME
EOF
```

5. Create a stop shell script.

```bash
cat > /home/oracle/scripts/stop_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbshut \$ORACLE_HOME
EOF
```

6. Update the owner and permission of the shell scripts and its parent directory.

```bash
chown -R oracle:oinstall /home/oracle
chmod u+x /home/oracle/scripts/*.sh
```

7. Set the environment when the Bash runs whenever it is started interactively.

```bash
cat > /home/oracle/.bashrc <<EOF
#.bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

. /home/oracle/scripts/setEnv.sh >> /home/oracle/.bashrc
EOF

chown oracle:oinstall /home/oracle/.bashrc
```

## Create and Add New Swap File

1. Run the following command, with **`oracle` user**, to create and apply new swap file.

```bash
dd if=/dev/zero of=/tmp/additional-swap bs=1048576 count=4096
chmod 600 /tmp/additional-swap
mkswap /tmp/additional-swap
```

2. Apply the swap by executing the following command with **`root` user**.

```bash
swapon /tmp/additional-swap
```

## Install Oracle Database
Your client must client software "xming" for display (X11) 
1. Set the DISPLAY variable with **`oracle` user**.

```bash
DISPLAY=$HOSTNAME:0.0; export DISPLAY
```

2. Unzip the archive with **`oracle` user**.

```bash
cd $ORACLE_HOME
unzip -oq /path/to/software/LINUX.X64_193000_db_home.zip
```

3. "Cheat" the installer about the distribution with **`oracle` user**.

```bash
export CV_ASSUME_DISTID=RHEL7.6
```

4. Run the installer, with **`oracle` user**, to install Oracle database.

```bash
cd $ORACLE_HOME
./runInstaller -ignorePrereq -waitforcompletion -silent                        \
    -responseFile ${ORACLE_HOME}/install/response/db_install.rsp               \
    oracle.install.option=INSTALL_DB_SWONLY                                    \
    ORACLE_HOSTNAME=${ORACLE_HOSTNAME}                                         \
    UNIX_GROUP_NAME=oinstall                                                   \
    INVENTORY_LOCATION=${ORA_INVENTORY}                                        \
    SELECTED_LANGUAGES=en,en_GB                                                \
    ORACLE_HOME=${ORACLE_HOME}                                                 \
    ORACLE_BASE=${ORACLE_BASE}                                                 \
    oracle.install.db.InstallEdition=EE                                        \
    oracle.install.db.OSDBA_GROUP=dba                                          \
    oracle.install.db.OSBACKUPDBA_GROUP=dba                                    \
    oracle.install.db.OSDGDBA_GROUP=dba                                        \
    oracle.install.db.OSKMDBA_GROUP=dba                                        \
    oracle.install.db.OSRACDBA_GROUP=dba                                       \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                 \
    DECLINE_SECURITY_UPDATES=true
```

5. If the setup is success, the following message should be printed on screen.

```
Successfully Setup Software.
```

6. Execute the below scripts, with **`root` user**, to update the permission of Oracle directories and set the environment variables.

```bash
/u01/app/oraInventory/orainstRoot.sh
/u01/app/oracle/product/19.3.0/dbhome_1/root.sh
```

## Database Creation

1. Start the listener with **`oracle` user**.

```bash
lsnrctl start
```

2. Create a database with **`oracle` user**.

```bash
./dbca 
```

## Post Installation

1. Edit the `/etc/oratab` file, with **`root` user**, to update the restart flag from '`N`' to '`Y`'.

```bash
orcl:/u01/app/oracle/product/19.3.0/dbhome_1:Y
```

2. Configure the Database instance "orcl" with auto startup.

```bash
cd $ORACLE_HOME/dbs
ln -s spfilecdb1.ora initorcl.ora
```


3. Execute the following commands, with **`root` user**, to start the Oracle Listener automatically.

```bash
cat > /home/oracle/scripts/cron.sh <<EOF1
#!/bin/bash

. /home/oracle/scripts/setEnv.sh

echo "\`date\`" > /home/oracle/scripts/last.log

lsnrctl start

sleep 3

lsnrctl reload

sleep 3

sqlplus / as sysdba <<EOF
sqlplus / as sysdba
startup
EOF

EOF1

chown oracle:oinstall /home/oracle/scripts/cron.sh
chmod 744 /home/oracle/scripts/cron.sh
```

5. Use the following command, with **`oracle` user**,  to edit the crontab file.

```bash
crontab -e
```

6. Put the following cron job in the first line of crontab file, then press the keys `:wq` to save and exit.

```bash
@reboot /home/oracle/scripts/cron.sh
```


## Create New User and Tablespace

1. Login as Sysdba with SqlPlus.

```bash
sqlplus / as sysdba
SELECT tablespace_name FROM dba_Tablespaces;
CREATE TABLESPACE "<Your Name>" DATAFILE 
  '/u01/oradata/<Your Name>_tbs01.dbf' SIZE 25G AUTOEXTEND ON;
SELECT tablespace_name FROM dba_Tablespaces;
```

5. Create a new user.

```sql
-- ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- DROP USER <YourUser> CASCADE;
CREATE USER <YourUser> IDENTIFIED BY "<Your Password>";
alter user <YourUser> default tablespace <Your Tablespace>;
```

6. Grant permissions to the new user.

```sql
-- REVOKE CREATE SESSION FROM <YourUser>;
-- REVOKE CREATE TABLE FROM <YourUser>;
-- REVOKE CREATE VIEW FROM <YourUser>;
-- REVOKE CREATE ANY TRIGGER FROM <YourUser>;
-- REVOKE CREATE ANY PROCEDURE FROM <YourUser>;
-- REVOKE CREATE SEQUENCE FROM <YourUser>;
-- REVOKE CREATE SYNONYM FROM <YourUser>;
GRANT CREATE SESSION TO <YourUser>;
GRANT CREATE TABLE TO <YourUser>;
GRANT CREATE VIEW TO <YourUser>;
GRANT CREATE ANY TRIGGER TO <YourUser>;
GRANT CREATE ANY PROCEDURE TO <YourUser>;
GRANT CREATE SEQUENCE TO <YourUser>;
GRANT CREATE SYNONYM TO <YourUser>;

ALTER USER <YourUser> QUOTA UNLIMITED ON <Your Tablespace>;
```

7. [Optional] Grant DBA to the new user.

```sql
-- REVOKE DBA FROM <Your Tablespace>;
GRANT DBA TO <Your Tablespace>;
```
# Import / Export Database 19C
```sql
# Export
expdp \"SYS/<yourpassword>@orcl as sysdba\"  directory=DATA_PUMP_DIR dumpfile=<Your_name_database>.dmp logfile=exp_<Your_name_database>.log Full=y
# Import
impdp \"SYS/<yourpassword>@orcl as sysdba\"  directory=DATA_PUMP_DIR dumpfile=<Your_name_database>.dmp logfile=imp_<Your_name_database>.log Full=y
```

