#!/bin/sh

echo =================================================================\n
echo               Semi-automated script for TOMCAT
echo                      Motif Technology Plc.
echo Revision Edit 01 - 2020-01-22 by Infra Kanyapat.c
echo =================================================================\n

# Setting variables. Pleae make sure you do update this every time before install.


# ===================================== Create Directory ============================================ #
# The standard directory creation method for every project and the user name is Motif.                #
# You must also use Root rights to create the directory.                                              #

echo "==================== Create Directory with Root ====================" 
mkdir  /app
mkdir  /app/motif
mkdir  /app/motif/setup
mkdir  /app/motif/java
mkdir  /app/motif/apache
echo "+------------------------------------------------------------------+" 

# You also need to have the IT staff from customers create a user group for Motif.
# To move the software to the server. The IT staff from the customer will be to help. After that, 
# upload the files and software extract file to the path directory.
# You must edit the name directory before the move.

echo "================= Move File to Directory with Root ================="
mv /app/motif/setup/<yournamefile>  /app/motif/apache
mv /app/motif/setup/<yournamefile> /app/motif/java
echo "+------------------------------------------------------------------+"

# Open Firewall 
echo "==================== Open Fireware with Root ======================="
firewall-cmd --zone=public --permanent --add-port=80/tcp
firewall-cmd --zone=public --permanent --add-port=443/tcp
firewall-cmd --zone=public --permanent --add-port=8080/tcp
firewall-cmd --reload
firewall-cmd --list-all
echo "+------------------------------------------------------------------+"


echo "================ Setting Service Tomcat with Root =================="
export TOMCAT_HOME=/app/motif/apache/<yournamefile>
export JAVA_HOME=/app/motif/java/<yournamefile>
export PATH=$PATH:$HOME/bin:$JAVA_HOME/bin:$TOMCAT_HOME/bin
mv  /app/motif/setup/tomcat /etc/init.d
echo "+------------------------------------------------------------------+"

# Grant tomcat privileges with the command "chmod 755 tomcat"
echo "================ Setting Symbolic Tomcat with Root ================="
ln -s /etc/init.d/tomcat /etc/rc.d/rc0.d/K01tomcat
ln -s /etc/init.d/tomcat /etc/rc.d/rc1.d/K01tomcat
ln -s /etc/init.d/tomcat /etc/rc.d/rc2.d/S99tomcat
ln -s /etc/init.d/tomcat /etc/rc.d/rc3.d/S99tomcat
ln -s /etc/init.d/tomcat /etc/rc.d/rc4.d/S99tomcat
ln -s /etc/init.d/tomcat /etc/rc.d/rc5.d/S99tomcat
ln -s /etc/init.d/tomcat /etc/rc.d/rc6.d/K01tomcat
systemctl daemon-reload
systemctl start tomcat.service
systemctl stop tomcat.service
systemctl start tomcat.service
systemctl status tomcat.service

echo "+------------------------------------------------------------------+"

/bin/echo "script has been Install finished successfully "
