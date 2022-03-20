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
echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo
echo "========================= Operating System ID ======================" | tee -a $motif_file_sysinfo
echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo
uname -a  | tee -a $motif_file_sysinfo
echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo

echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo
echo "============================ Host Name =============================" | tee -a $motif_file_sysinfo
echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo
/usr/bin/hostnamectl | tee -a $motif_file_sysinfo
echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo

echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo
echo "=========================== Host Uptime ============================" | tee -a $motif_file_sysinfo
echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo
/usr/bin/uptime | tee -a $motif_file_sysinfo
echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo
/usr/bin/w | tee -a $motif_file_sysinfo
echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinf

echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo
echo "======================== System Information ========================" | tee -a $motif_file_sysinfo
echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo
cat /etc/os-release -v  | tee -a $motif_file_sysinfo
echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo

echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo
echo "==================== Gathering User Login History ==================" | tee -a $motif_file_sysinfo
echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo
last -an 500 | tee -a $motif_file_sysinfo
echo "+------------------------------------------------------------------+" | tee -a $motif_file_sysinfo


echo "+-----------------------------------------------------------------------+" | tee -a $motif_file_process
echo "====================== CPU and Process Information ======================" | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------+" | tee -a $motif_file_process
#There is no blacklisted processes yet. Please check and identified dubious process manually for the time being.
lscpu    | tee -a $motif_file_process  
echo "+-----------------------------------------------------------------------+" | tee -a $motif_file_process
less /proc/cpuinfo   | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------+" | tee -a $motif_file_process
cat /proc/cpuinfo    | grep processor | wc -l    | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------+" | tee -a $motif_file_process
cat /proc/cpuinfo      grep 'core id'  | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------+" | tee -a $motif_file_process
nproc  | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------+" | tee -a $motif_file_process
dmesg | grep CPU       | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------+" | tee -a $motif_file_process


echo "+----------------------------------------------------------------------------------+" | tee -a $motif_file_process
echo "========================= CPU Usage and Process Information ========================" | tee -a $motif_file_process
echo "+----------------------------------------------------------------------------------+" | tee -a $motif_file_process
CPU_USAGE=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }')
DATE=$(date "+%Y-%m-%d %H:%M:")
printf "\n===== CPU_USAGE:" | tee -a $motif_file_process
CPU_USAGE="$DATE CPU: $CPU_USAGE"   | tee -a $motif_file_process
echo "+----------------------------------------------------------------------------------+" | tee -a $motif_file_process
echo $CPU_USAGE | tee -a $motif_file_process
echo "+----------------------------------------------------------------------------------+" | tee -a $motif_file_process
top -bn1 | head -20  | tee -a $motif_file_process
echo "+----------------------------------------------------------------------------------+" | tee -a $motif_file_process
echo "Top CPU Process Using ps command" | tee -a $motif_file_process
echo "+----------------------------------------------------------------------------------+" | tee -a $motif_file_process
ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10 | tee -a $motif_file_process
echo "+----------------------------------------------------------------------------------+" | tee -a $motif_file_process


echo "+----------------------------------------------------------------------------+" | tee -a $motif_file_process
echo "========================= Memory Infomation Detail =========================="  | tee -a $motif_file_process
echo "+----------------------------------------------------------------------------+" | tee -a $motif_file_process
cat /proc/meminfo | tee -a $motif_file_process
echo "+----------------------------------------------------------------------------+" | tee -a $motif_file_process
echo "======================== Process Resource Statistics =========================" | tee -a $motif_file_process
echo "+----------------------------------------------------------------------------+" | tee -a $motif_file_process
egrep --color 'Mem|Cache|Swap' /proc/meminfo     | tee -a $motif_file_process
echo "+----------------------------------------------------------------------------+" | tee -a $motif_file_process
free -mt | tee -a $motif_file_process
# display memory in megabyte and total line
echo "+----------------------------------------------------------------------------+" | tee -a $motif_file_process
free -l  | tee -a $motif_file_process
# Show Low and High Memory Statistics
echo "+----------------------------------------------------------------------------+" | tee -a $motif_file_process
dmesg | grep memory  | tee -a $motif_file_process
echo "+----------------------------------------------------------------------------+" | tee -a $motif_file_process

echo "+-----------------------------------------------------------------------------+" | tee -a $motif_file_process
echo "=============================== VMStat Summary ==============================="  | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------------+" | tee -a $motif_file_process
vmstat -s         | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------------+" | tee -a $motif_file_process
vmstat -dt        | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------------+" | tee -a $motif_file_process
vmstat -a 1 30    | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------------+" | tee -a $motif_file_process
mpstat -P ALL     | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------------+" | tee -a $motif_file_process
sar -P ALL 1 30   | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------------+" | tee -a $motif_file_process
sar -b 1 30    | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------------+" | tee -a $motif_file_process
ps -f -u root    | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------------+" | tee -a $motif_file_process


#echo kstat -m cpu_stat | egrep user |idle |kernel |wait  for Solaris 9 and earlier versions %wio wont reported as 0 >> $motif_pm_output
echo "+-----------------------------------------------------------------------------+" | tee -a $motif_file_process
echo "================================== Data =======================================" | tee -a $motif_file_process
echo "+-----------------------------------------------------------------------------+" | tee -a $motif_file_process
/usr/bin/date  | tee -a $motif_file_process
/usr/bin/cal   | tee -a $motif_file_process

echo "+------------------------------------------------------------------------------+" | tee -a $motif_file_storage
echo "============================== Disk IO Statistics ==============================" | tee -a $motif_file_storage
echo "+------------------------------------------------------------------------------+" | tee -a $motif_file_storage
iostat -p /dev/sda | tee -a $motif_file_storage
echo "+------------------------------------------------------------------------------+" | tee -a $motif_file_storage
iostat -p /dev/sdb | tee -a $motif_file_storage
echo "+------------------------------------------------------------------------------+" | tee -a $motif_file_storage
iostat -p /dev/sdc | tee -a $motif_file_storage
echo "+------------------------------------------------------------------------------+" | tee -a $motif_file_storage
iostat -xtc 5 2    | tee -a $motif_file_storage
echo "+------------------------------------------------------------------------------+" | tee -a $motif_file_storage


echo "+-----------------------------------------------------------------------------------------------+" | tee -a $motif_file_storage
echo "========================================== Disk Free Space ======================================" | tee -a $motif_file_storage
echo "+-----------------------------------------------------------------------------------------------+" | tee -a $motif_file_storage
df -h  | tee -a $motif_file_storage
echo "+-----------------------------------------------------------------------------------------------+" | tee -a $motif_file_storage
df -i  | tee -a $motif_file_storage
echo "+-----------------------------------------------------------------------------------------------+" | tee -a $motif_file_storage
df --o | tee -a $motif_file_storage
echo "+-----------------------------------------------------------------------------------------------+" | tee -a $motif_file_storage


echo "+-----------------------------------------------------------------------------------------------+" | tee -a $motif_file_storage
echo "=================================== Reporting Disk Activities ===================================" | tee -a $motif_file_storage
echo "+-----------------------------------------------------------------------------------------------+" | tee -a $motif_file_storage
/usr/bin/iostat 4 3 | tee -a $motif_file_storage
echo "+-----------------------------------------------------------------------------------------------+" | tee -a $motif_file_storage
/usr/bin/iostat -cdhkNxy | tee -a $motif_file_storage
echo "+-----------------------------------------------------------------------------------------------+" | tee -a $motif_file_storage


#echo "\n===== Reporting Disk Errors ======:" | tee -a $motif_file_storage
#badblocks -sv /dev/sda | tee -a $motif_file_storage
#smartctl  -H  /dev/sda | tee -a $motif_file_storage
#badblocks -sv /dev/sdb | tee -a $motif_file_storage
#smartctl  -H  /dev/sdb | tee -a $motif_file_storage
#badblocks -sv /dev/sdc | tee -a $motif_file_storage
#smartctl  -H  /dev/sdc | tee -a $motif_file_storage

echo "+----------------------------------------------------------------------------+" | tee -a $motif_file_network
echo "========================= Network Interface Config ===========================" | tee -a $motif_file_network
echo "+----------------------------------------------------------------------------+" | tee -a $motif_file_network
ifconfig -a  | tee -a $motif_file_network
echo "+----------------------------------------------------------------------------+" | tee -a $motif_file_network

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
echo "+---------------------------------------------------------------------------+" | tee -a $motif_file_network

echo "+---------------------------------------------------------------------------+" | tee -a $motif_file_network
echo "============================ Routing Information ============================" | tee -a $motif_file_network
echo "+---------------------------------------------------------------------------+" | tee -a $motif_file_network
netstat -rn  | tee -a $motif_file_network
echo "+---------------------------------------------------------------------------+" | tee -a $motif_file_network
netstat -an | more   | tee -a $motif_file_network
echo "+---------------------------------------------------------------------------+" | tee -a $motif_file_network
netstat -ntlp | grep LISTEN  | tee -a $motif_file_network
echo "+---------------------------------------------------------------------------+" | tee -a $motif_file_network

echo "+---------------------------------------------------------------------------+" | tee -a $motif_file_oslog
echo "============================ Opareting System Error =========================" | tee -a $motif_file_oslog
echo "+---------------------------------------------------------------------------+" | tee -a $motif_file_oslog
printf "\n===== OS Errors:" | tee -a $motif_file_oslog
dmesg | tee -a $motif_file_oslog
echo "+---------------------------------------------------------------------------+" | tee -a $motif_file_oslog

 


/bin/echo "script has been finished successfully "

tar -zcvf "apposcheck-logs_$(date '+%Y-%m-%d').tar.gz" /app/motif/logs/*
