#!/bin/sh

echo =================================================================\n
echo               Semi-automated script for MYSQL 
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

echo "+------------------------------------------------------------------+" 

# You must ensure that the client's server can use the internet.
echo "========== Downloads Packet Mysql to Directory with Root ==========="
cd /app/motif/setup
wget https://dev.mysql.com/get/mysql-community-common-8.0.15-1.el7.x86_64.rpm
wget https://dev.mysql.com/get/mysql-community-libs-8.0.15-1.el7.x86_64.rpm
wget https://dev.mysql.com/get/mysql-community-client-8.0.15-1.el7.x86_64.rpm
wget https://dev.mysql.com/get/mysql-community-server-8.0.15-1.el7.x86_64.rpm

echo "+------------------------------------------------------------------+"

echo "=========== Install Packet Mysql to Directory with Root ============"
yum remove postfix
rpm -Uvh /app/motif/setup/mysql-community-common-8.0.15-1.el7.x86_64.rpm
rpm -Uvh /app/motif/setup/mysql-community-libs-8.0.15-1.el7.x86_64.rpm
rpm -Uvh /app/motif/setup/mysql-community-client-8.0.15-1.el7.x86_64.rpm
rpm -Uvh /app/motif/setup/mysql-community-server-8.0.15-1.el7.x86_64.rpm

echo "+------------------------------------------------------------------+"

# Open Firewall 
echo "==================== Open Fireware with Root ======================="
firewall-cmd --zone=public --permanent --add-port=3306/tcp
firewall-cmd --reload
firewall-cmd –-list-all

echo "+------------------------------------------------------------------+"

echo "================ Start Service MySQL with Root ================="
systemctl start mysqld.service

echo "+------------------------------------------------------------------+"

/bin/echo "script has been Install finished successfully Get password for mysql "

grep 'temporary password' /var/log/mysqld.log
# Copy password from logs. And input in mysql_secure_installation for change new password
mysql_secure_installation
