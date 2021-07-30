#!/bin/bash

. /home/oracle/scripts/setEnv.sh

echo "`date`" > /home/oracle/scripts/last.log

lsnrctl start

sleep 3

lsnrctl reload

sleep 3

sqlplus / as sysdba <<EOF
sqlplus / as sysdba
startup
EOF

