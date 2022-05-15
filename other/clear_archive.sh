#!/bin/sh
export  TMP=/app/tmp
export TMPDIR=$TMP

export ORACLE_HOSTNAME=<YourHostname>
export ORACLE_UNQNAME=orcl
export ORACLE_BASE=/app/oracle
export ORACLe_HOME=$ORACLE_BASE/product/19.3.0/dbhome_1
export ORA_INVENTORY=/app/oraInventory
export ORACLE_SID=orcl
export PDB_NAME=pdb
export DATA_DIR=/app/oradata

export PATH=/usr/sbin:/usr/local/bin:$PATH
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/libe
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

### Function to delete archive logs ###

delarch () {
    rman log=/home/oracle/scripts/uat/log/delete_arch.log << EOF
    connect targat /
    DELETE noprompt ARCHIVELOG ALL COMPLETED BEFORE 'sysdate-1';
    DELETE noprompt ARCHIVELOG ALL COMPLETED BEFORE 'sysdate-2';
    DELETE noprompt ARCHIVELOG ALL COMPLETED BEFORE 'sysdate-3';
    CROSSCHECK ARCHIVELOG ALL;
    DELETE EXPIRED ARCHIVELOG ALL;
    exit
    EOF
}

###############################
# Main to call archive delete #
echo "Deleting Archive Logs"
delarch
echo "Successfully deleted archives"