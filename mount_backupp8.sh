#!/bin/sh
echo $xDate
lspv
importvg -y backupvg 00f9e88dec775701
lspv
mount /backupp8
df -Pg
chown oracle:oinstall /backupp8/dumpdb/dmslife
chown oracle:oinstall /backupp8/dumpdb/dmsnlife
