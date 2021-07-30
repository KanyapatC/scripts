#!/bin/sh

echo ==============================================\n
echo Semi-automated test script for Ubuntu 16.04.6 LTS
echo Motif Technology Plc.
echo Revision Edit 04 - 2019-03-08 by Kanyapat.c , own Wittaya W.
echo ==============================================\n

# Setting variables. Pleae make sure you do update this every time.
motif_report_home=$PWD
export motif_report_home

motif_file_sysinfo=$motif_report_home/sysinfo.txt
export motif_file_sysinfo
motif_file_process=$motif_report_home/process.txt
export motif_file_process
motif_file_storage=$motif_report_home/storage.txt
export motif_file_storage
motif_file_network=$motif_report_home/network.txt
export motif_file_network
motif_file_oslog=$motif_report_home/oslog.txt
export motif_file_oslog


# ===== System Information ===========================================
# Currently not automated. Please take the output files and make report to customer yourself. Sorry.
# OS Information

echo "========== Preventive Maintenance Report ==========" | tee $motif_file_sysinfo
echo "========== Preventive Maintenance Report ==========" | tee $motif_file_process
echo "========== Preventive Maintenance Report ==========" | tee $motif_file_storage
echo "========== Preventive Maintenance Report ==========" | tee $motif_file_network
echo "========== Preventive Maintenance Report ==========" | tee $motif_file_

echo "" | tee -a $motif_file_sysinfo
echo "\n\n===== Operating System ID =====" | tee -a $motif_file_sysinfo
uname -a  | tee -a $motif_file_sysinfo

echo "\n\n===== Host Name: " | tee -a $motif_file_sysinfo
/usr/bin/hostname | tee -a $motif_file_sysinfo

echo "\n\n===== Host Uptime: " | tee -a $motif_file_sysinfo
/usr/bin/uptime | tee -a $motif_file_sysinfo

echo "\n\n===== System Information\n" | tee -a $motif_file_sysinfo
prtdiag -v  | tee -a $motif_file_sysinfo

echo "\n\n===== Gathering User Login History" | tee -a $motif_file_sysinfo

printf "\n\n===== Login Attempts\n" | tee -a $motif_file_sysinfo
last | tee -a $motif_file_sysinfo


echo ==== 2 CPU and Process Information =====
#There is no blacklisted processes yet. Please check and identified dubious process manually for the time being.

echo "\n\n===== Process Resource Statistics - prstat\n\n" | tee -a $motif_file_process
prstat -a 1 1 | tee -a $motif_file_process

echo "\n\n===== Service Status\n\n" | tee -a $motif_file_process

echo "\n\n===== Service Count:\n\n"  | tee -a $motif_file_process 
svcs -a  | tee -a $motif_file_process

echo "\n\n===== VMStat Summary =====\n\n"  | tee -a $motif_file_process
vmstat -s | tee -a $motif_file_process

echo "\n\n===== VMStat Process Detail =====\n\n"  | tee -a $motif_file_process
vmstat -p 60 5 | tee -a $motif_file_process

echo "\n\n===== Reporting report virtual memory statistics =====" | tee -a $motif_file_process
vmstat 3 4 >> $motif_file_process | tee -a $motif_file_process



echo "\n\n===== Disk IO Statistics iostat -en \n\n" | tee -a $motif_file_storage
iostat -en | tee -a $motif_file_storage

echo "\n\n===== Disk Free Space df kh \n"| tee -a $motif_file_storage
df -kh | tee -a $motif_file_storage

echo "\n\n===== Reporting Disk Activities" | tee -a $motif_file_storage
/usr/bin/iostat 4 3 | tee -a $motif_file_storage

echo "\n\n===== Reporting Disk Activities" | tee -a $motif_file_storage
/usr/bin/iostat -xPnce | tee -a $motif_file_storage

echo "\n\n===== Reporting Disk Errors" | tee -a $motif_file_storage
/usr/bin/iostat -En | tee -a $motif_file_storage

echo "System Activities:"  | tee -a $motif_file_storage
/usr/bin/sar 5 10  | tee -a $motif_file_storage



#echo kstat -m cpu_stat | egrep user |idle |kernel |wait  for Solaris 9 and earlier versions %wio wont reported as 0 >> $motif_pm_output
echo "\n\n===== kstat #1" | tee -a $motif_file_process
/usr/bin/date  | tee -a $motif_file_process
/usr/bin/kstat -m cpu_stat | egrep user |idle |kernel |wait  | tee -a $motif_file_process
/usr/bin/sleep 10
echo "\n\n===== kstat #2"  | tee -a $motif_file_process
/usr/bin/kstat -m cpu_stat | egrep user |idle |kernel |wait  | tee -a $motif_file_process



echo "Network Interface Config" | tee -a $motif_file_network
ifconfig -a  | tee -a $motif_file_network


# Need to update to handle .bak .orig, etc...
# Check interfaces are plumbed, up and full duplex.
for iface in `ls /etc/hostname.*|awk '{ FS=".";print $2 }'`
do
 if dladm show-dev | grep $iface | grep up | grep full > /dev/null
 then
  echo "Network: $iface is up and full duplex" | tee -a $motif_file_network
 else
  echo "Network: `dladm show-dev | grep $iface`"  | tee -a $motif_file_network
 fi
done

echo "\n\n===== Routing Information\n"  | tee -a $motif_file_network
netstat -rn  | tee -a $motif_file_network



echo "\n\n===== OS Errors - Critical \n" | tee -a $motif_file_oslog
dmesg | grep -c 'crit'  | tee -a $motif_file_oslog
echo "\n\n===== OS Errors - Error \n" | tee -a $motif_file_oslog
dmesg | grep -c 'error' | tee -a $motif_file_oslog
echo "\n\n===== OS Errors - warn \n" | tee -a $motif_file_oslog
dmesg | grep -c 'warn' | tee -a $motif_file_oslog



echo "\n\n===== Listing Swap devices:\n" | tee -a $motif_file_sysinfo
/usr/sbin/swap -l | tee -a $motif_file_sysinfo

echo "\n\n===== Swap Summary\n" | tee -a $motif_file_sysinfo
/usr/sbin/swap -s | tee -a $motif_file_sysinfo

echo "\n\n===== Hot swap pool\n" | tee -a $motif_file_storage
/usr/sbin/metadb | tee -a $motif_file_storage

echo "\n\n===== Hot swap pool\n" | tee -a $motif_file_storage
/usr/sbin/metastat | tee -a $motif_file_storage

echo "\n\n===== CPU / MEM Log and Overall Log Records" | tee -a $motif_file_process
/usr/bin/grep -i afsr /var/adm/me*  | tee -a $motif_file_process
/usr/bin/grep -i afar /var/adm/me*  | tee -a $motif_file_process
/usr/bin/grep -i error /var/adm/me* | tee -a $motif_file_process
/usr/bin/grep -i fail /var/adm/me*  | tee -a $motif_file_process
/usr/bin/grep -i panic /var/adm/me* | tee -a $motif_file_process
/usr/bin/grep -i scsi /var/adm/me*  | tee -a $motif_file_process

echo "\n\n===== Reporting Crash Files\n" | tee -a $motif_file_oslog
/usr/bin/ls -lh /var/crash/`hostname`/  | tee -a $motif_file_oslog

/usr/bin/echo "Reporting  Hardware issues:"  | tee -a $motif_file_oslog
/usr/platform/`uname -i`/sbin/prtdiag -v  | tee -a $motif_file_oslog

/usr/bin/echo "script has been finished successfully "

