# Install Weblogic 12.2.1.4.0 on CentOS 8 

** Please use the `root` user to edit the files and execute the commands unless further notice. **

## Prerequisite

1. Install and Download the latest [CentOS Stream 8](https://www.centos.org/download/).

2. After installing the CentOS, execute the following commands to get the required libraries to create applications for handling compiled objects.

```
yum update
```

3. Open the file `/etc/hostname`, change the content to update the hostname.

```
localhost.localdomain
```

2. Open the file `/etc/hosts`, add your IP address and hostname.

```
<Your IP Address>  localhost.localdomain
```

## Create directory necessary for Software
## Recommend separate disk mount path /u01 because we will create directory only
1. create user and group

```bash
groupadd oinstall
useradd -g oinstall oracle
passwd oracle
```

2. create directory under path /u01

```bash
mkdir /u01/java
mkdir /u01/oracle
mkdir /u01/scripts
mkdir /u01/setup
```

3. Add execute permission user `oracle` and group `oinstall` to /u01.

```bash
chown -R oracle:oinstall /u01
```

## Install WebLogic 12.2.1.4.0 Installation Prerequisites
** Please use the `oracle` user to edit the files and execute the commands unless further notice. **

1. Install Java 8u291 and download file to /u01/setup.

```bash
cd /u01/setup/
```
2. Open jdk-8u291-linux-X64.tar.gz from download to https://www.oracle.com/in/java/technologies/javase/javase8u211-later-archive-downloads.html

```bash
tar -zxvf jdk-8u291-linux-X64.tar.gz
mv jdk1.8.0_291  /u01/java
```

** Please use the `root` user to execute the commands install Java. **

```bash
alternatives --install /usr/bin/java java /u01/java/jdk1.8.0_291/bin/java 2
alternatives --config java
# Select your java install
alternatives --install /usr/bin/jar jar /u01/java/jdk1.8.0_291/bin/jar 2
alternatives --install /usr/bin/javac javac /tlegal/app/lms/java/amazon-correntto8.212.04.2/bin/javac 2
alternatives --set jar /u01/java/jdk1.8.0_291/bin//bin/jar
alternatives --set javac /u01/java/jdk1.8.0_291/bin/bin/javac
```
** Please use the `oracle` user to edit the files and execute the commands unless further notice. **

3. Add enviroment in vim .bash_profile.
```bash
## .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

JAVA_HOME=/u01/java/jdk1.8.0_291
export JAVA_HOME
PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
# User specific environment and startup programs

JAVA_HOME=/u01/java/jdk1.8.0_291
export JAVA_HOME
WLS_HOME=/u01/oracle/middleware/wls12214/user_projects/domains/base_domain
export WLS_HOME
PATH=$PATH:$JAVA_HOME/bin:$WLS_HOME/bin
```

```bash
export JAVA_HOME=/u01/java/jdk1.8.0_291
```

```bash
cp -p .bash_profile /home/oracle/scripts/setenv.sh
```

4. Open fmw_12.2.1.4.0_wls_quick_Disk1_1of1.zip from download to https://www.oracle.com/middleware/technologies/weblogic-server-installers-downloads.html#license-lightbox

```bash
unzip fmw_12.2.1.4.0_wls_quick_Disk1_1of1.zip
```

5. install weblogic with user `oracle`.

```bash
java -jar fmw_12.2.1.4.0_wls_quick.jar
```
In during install weblogic setting WLS_HOME
But your client must client software "xming" for display (X11) install weblogic
With follow Step
  - Step 1 of 9 - Welcome	Click Next.
  - Step 2 of 9 - Auto Updates	Select Skip Auto Updates. Click Next.
  - Step 3 of 9 - Installation Location	Enter /u01/oracle/middleware/wls12214 for Middleware Home. Click Next.
  - Step 4 of 9 - Installation Type	Select Complete with Examples. If it is production box, Please choose weblogic server Click Next.
  - Step 5 of 9 - Prerequisite Checks	Click Next.
  - Step 6 of 9 - Security UpdatesUnselect I wish to receive security updates via My Oracle Support. 
    Click Next. My Oracle Support Username/Email Address Not Specified	Click Yes.
  - Step 7 of 9 - Installation Summary	Click Install.
  - Step 8 of 9 - Installation Progress	Click Next.
  - Step 9 of 9 - Installation Complete	Click Finish.

6. Create weblogic domain.

```bash
cd /u01/oracle/middleware/wls12214/wlserver/common
./config.sh
```

Check "Available Templates"
- Weblogic Advanced Web Services for JAX-RPC Extenstion oracle_common
- Weblogic Advanced Web Services for JAX-WS Extenstion oracle_common
- Weblogic JAX-WS SOAP/JMS Extenstion oracle_common


** Please use the `root` user to execute the commands unless further notice. **
7. Open the firewall.

```bash
 firewall-cmd --zone=public --permanent --add-port=7001/tcp
 firewall-cmd --zone=public --permanent --add-port=7003/tcp
 firewall-cmd --reload
```

** Please use the `oracle` user to execute the commands unless further notice. **
## Create script for start/stop weblogic automatically

1. Create scripts directories.

```bash
mkdir /home/oracle/scripts
cd /home/oracle/scripts/
touch setenv.sh
touch start_all.sh
touch stop_all.sh
touch weblogic.sh
```
```bash
vim setenv.sh
PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
# User specific environment and startup programs

JAVA_HOME=/u01/java/jdk1.8.0_291
export JAVA_HOME
WLS_HOME=/u01/oracle/middleware/wls12214/user_projects/domains/base_domain
export WLS_HOME
PATH=$PATH:$ORACLE_HOME/bin:$WLS_HOME/bin
```
```bash
vim start_all.sh
#!/bin/bash

# Setup Init variables
. /home/oracle/scripts/setenv.sh

# Define Startup steps
  nohup /u01/oracle/middleware/wls12214/user_projects/domains/base_domain/bin/startWebLogic.sh > /u01/oracle/wls12214/user_projects/domains/base_domain/bin/nohup-Admin.out 2>&1 &
  sleep 10

  nohup /u01/oracle/middleware/wls12214/user_projects/domains/base_domain/bin/startManagedWebLogic.sh Server1 t3://<Your hostname or ip address>:7001 > /u01/oracle/wls12214/user_projects/domains/base_domain/bin/nohup-Server1.out 2>&1 &
```

```bash
vim stop_all.sh
#!/bin/bash

# Setup Init variables
. /home/oracle/scripts/setenv.sh

# Define Stop steps

  nohup /u01/oracle/wls12214/user_projects/domains/base_domain/bin/stopManagedWebLogic.sh Server1 t3://<Your hostname or ip address>:7001 > /u01/oracle/wls12214/user_projects/domains/base_domain/bin/nohup-Server1.out 2>&1 &
  sleep 10
  nohup /u01/oracle/wls12214/user_projects/domains/base_domain/bin/stopWebLogic.sh > /u01/oracle/wls12214/user_projects/domains/base_domain/bin/nohup-Admin.out 2>&1 &
```

```bash
vim weblogic.sh
#!/bin/bash


# Define Startup steps
  nohup /u01/oracle/wls12214/user_projects/domains/base_domain/bin/startWebLogic.sh > /u01/oracle/wls12214/user_projects/domains/base_domain/bin/nohup-Admin.out 2>&1&
  sleep 10

  nohup /u01/oracle/wls12214/user_projects/domains/base_domain/bin/startManagedWebLogic.sh Server1 t3://<Your hostname or ip address>:7001 > /u01/oracle/wls12214/user_projects/domains/base_domain/bin/nohup-Server1.out 2>&1&
```

** Please use the `root` user to execute the commands unless further notice. **
3. Add permission 

```bash
corntab -e
chown -R oracle:oinstall /home/oracle/scritps/*
chmod 755 /home/oracle/scritps/*
```

** Please use the `oracle` user to execute the commands unless further notice. **

4. Setup crontab

```bash
corntab -e
# Add command
@reboot /home/oracle/scripts/weblogic.sh
```

