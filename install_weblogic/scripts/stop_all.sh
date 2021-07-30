#!/bin/bash

# Setup Init variables
. /home/oracle/scripts/setenv.sh

# Define Stop steps

  nohup /u01/oracle/middleware/wls12214/user_projects/domains/base_domain/bin/stopManagedWebLogic.sh Server1 t3://chubblife-icom-app.motif.corp:7001 > /u01/oracle/wls12214/user_projects/domains/base_domain/bin/nohup-Server1.out 2>&1 &
  sleep 10
  nohup /u01/oracle/middleware/wls12214/user_projects/domains/base_domain/bin/stopWebLogic.sh > /u01/oracle/wls12214/user_projects/domains/base_domain/bin/nohup-Admin.out 2>&1 &

