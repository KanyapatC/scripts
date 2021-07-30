#!/bin/sh

echo =================================================================\n
echo               Semi-automated test script for CentOS 
echo                      Motif Technology Plc.
echo Revision Edit 05 - 2020-01-07 by Kanyapat.c , own Wittaya W.
echo =================================================================\n

# Setting variables. Pleae make sure you do update this every time.
motif_report_home=/app/motif/logs
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


# ==================================== System Information =========================================== #
# Currently not automated. Please take the output files and make report to customer yourself. Sorry.  #
# OS Information                                                                                      #

echo "========== Preventive Maintenance Report ==========" | tee $motif_file_sysinfo
echo "========== Preventive Maintenance Report ==========" | tee $motif_file_process
echo "========== Preventive Maintenance Report ==========" | tee $motif_file_storage
echo "========== Preventive Maintenance Report ==========" | tee $motif_file_network


echo "" | tee -a $motif_file_sysinfo
echo "\n\n============== Operating System ID ============" | tee -a $motif_file_sysinfo
uname -a  | tee -a $motif_file_sysinfo

echo "\n===== Host Name: " | tee -a $motif_file_sysinfo
/usr/bin/hostnamectl | tee -a $motif_file_sysinfo

echo "\n===== Host Uptime: " | tee -a $motif_file_sysinfo
/usr/bin/uptime | tee -a $motif_file_sysinfo
echo "\n===== System Information:" | tee -a $motif_file_sysinfo
cat /etc/os-release -v  | tee -a $motif_file_sysinfo

echo "\n\n===== Gathering User Login History =====" | tee -a $motif_file_sysinfo
printf "\n===== Login Attempts:" | tee -a $motif_file_sysinfo
last -a | tee -a $motif_file_sysinfo


echo "\n\n=========== CPU and Process Information ============" | tee -a $motif_file_process
#There is no blacklisted processes yet. Please check and identified dubious process manually for the time being.

echo "\n===== Process Resource Statistics - Memory:\n" | tee -a $motif_file_process
lscpu    | tee -a $motif_file_process
free -mt | tee -a $motif_file_process

echo "\n===== VMStat Summary =====:\n"  | tee -a $motif_file_process
vmstat -s | tee -a $motif_file_process

echo "\n===== Memory Infomation Detail =====:\n"  | tee -a $motif_file_process
cat /proc/meminfo | tee -a $motif_file_process

#echo kstat -m cpu_stat | egrep user |idle |kernel |wait  for Solaris 9 and earlier versions %wio wont reported as 0 >> $motif_pm_output
echo "\n\n===== Data ====:\n" | tee -a $motif_file_process
/usr/bin/date  | tee -a $motif_file_process

echo "\n\n============= Disk IO Statistics ================" | tee -a $motif_file_storage
iostat -p /dev/sda | tee -a $motif_file_storage
iostat -p /dev/sdb | tee -a $motif_file_storage
iostat -p /dev/sdc | tee -a $motif_file_storage

echo "\n===== Disk Free Space ====:"| tee -a $motif_file_storage
df -h | tee -a $motif_file_storage

echo "\n===== Reporting Disk Activities =====:" | tee -a $motif_file_storage
/usr/bin/iostat 4 3 | tee -a $motif_file_storage

echo "\n===== Reporting Disk Activities =====:" | tee -a $motif_file_storage
/usr/bin/iostat -cdhkNxy | tee -a $motif_file_storage

#echo "\n===== Reporting Disk Errors ======:" | tee -a $motif_file_storage
#badblocks -sv /dev/sda | tee -a $motif_file_storage
#smartctl  -H  /dev/sda | tee -a $motif_file_storage
#badblocks -sv /dev/sdb | tee -a $motif_file_storage
#smartctl  -H  /dev/sdb | tee -a $motif_file_storage
#badblocks -sv /dev/sdc | tee -a $motif_file_storage
#smartctl  -H  /dev/sdc | tee -a $motif_file_storage


echo "================ Network Interface Config ==============="\n | tee -a $motif_file_network
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

echo "\n===== Routing Information:"  | tee -a $motif_file_network
netstat -rn  | tee -a $motif_file_network
netstat -ntlp | grep LISTEN  | tee -a $motif_file_network


echo "================ Opareting System Error ==============="\n | tee -a $motif_file_oslog
echo "\n===== OS Errors - Critical:" | tee -a $motif_file_oslog
dmesg | tee -a $motif_file_oslog

 


/bin/echo "script has been finished successfully "

tar -zcvf "baculaserver-logs_$(date '+%Y-%m-%d').tar.gz" /app/motif/logs/*
