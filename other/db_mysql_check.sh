#!/usr/bin/bash

#Script to run automated sql queries

#Declaring mysql DB connection 

MASTER_DB_USER='root'
MASTER_DB_PASSWD='Enterprise#1'
MASTER_DB_PORT=3306
MASTER_DB_HOST='localhost'
MASTER_DB_NAME='icas'

 
#File location
FILE="/app/motif/logs/mysqlcheck.txt"

#Verify CPU and Procress

SQL_PRO="show processlist;"
echo $SQL_PRO
echo "\n=====================================================" | tee $FILE

#Verify connection problems occur such as communication errors or aborted connections

STATUS="SHOW GLOBAL STATUS;"
echo $STATUS
echo "\n=====================================================" | tee $FILE

ABORTED_CONNECTS="SHOW GLOBAL STATUS LIKE 'aborted_connects';"
echo $ABORTED_CONNECTS
echo "\n=====================================================" | tee $FILE

#Verify lnnoDB detect Deadlocks

INNODB="SHOW ENGINE INNODB STATUS;"
echo $INNODB
echo "\n=====================================================" | tee $FILE
#verify maximun allowed coonection

MAX_CONNECTION="SHOW GLOBAL VARIABLES LIKE 'max_connections';"
echo $MAX_CONNECTION

echo "\n=====================================================" | tee $FILE
MAX_USE_CONNECTION="SHOW GLOBAL STATUS LIKE 'max_used_connections';"
echo $MAX_USE_CONNECTION

echo "\n=====================================================" | tee $FILE
#Verify full table scanns
HANDLER_READ='SHOW GLOBAL STATUS LIKE "Handler_read%";'
echo $HANDLER_READ


#mysql command to connect to database

mysql -u$MASTER_DB_USER -p$MASTER_DB_PASSWD -P$MASTER_DB_PORT -h$MASTER_DB_HOST -D$MASTER_DB_NAME > $FILE <<EOF 
$SQL_PRO $STATUS $ABORTED_CONNECTS $INNODB $MAX_CONNECTION $MAX_USE_CONNECTION $HANDLER_READ
EOF
echo "End of script"
