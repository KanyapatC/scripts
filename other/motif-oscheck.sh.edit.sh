#!/usr/bin/sh
echo ==============================================
echo Semi-automated test script for Solaris 10/11
echo Motif Technology Plc.
echo Revision 04 - 2015-09-14.
echo ==============================================
# Setting variables. Pleae make sure you do update this every time.
motif_report_home=$PWD
export motif_report_home
motif_report1=$motif_report_home/report_01.txt
export motif_report1
PATH=$PATH:/usr/sbin:/sbin:/usr/bin
# ====== System Information ===========================================
# Currently not automated. Please take the output files and make report to customer yourself. Sorry.
# OS Information
echo "========== Preventive Maintenance Report ==========" | tee $motif_report1
echo "" | tee -a $motif_report1
echo "===== Operating System ID =====" | tee -a $motif_report1
uname -a  | tee -a $motif_report1
echo "===== Host Name: " | tee -a $motif_report1
/usr/bin/hostname | tee -a $motif_report1
echo "===== Host Uptime: " | tee -a $motif_report1
/usr/bin/uptime | tee -a $motif_report1
echo "===== System Information: " | tee -a $motif_report1
prtdiag -v  | tee -a $motif_report1
printf "\n\n===== Login Attempts\n" | tee -a $motif_report1
last | tee -a $motif_report1
echo ==== 2 CPU and Process Information =====
#There is no blacklisted processes yet. Please check and identified dubious process manually for the time being.
echo "\n\n===== Process Resource Statistics - prstat\n\n" | tee -a $motif_report1
prstat -a 1 1 | tee -a $motif_report1
echo "\n\n===== Service Status\n\n" | tee -a $motif_report1
# NOTE - Effective 2015. We will no longer list all services in the system.
#      We will only check if the service absolutely necessary to us are responding
#      to our connection requests.
# svcs -a  | tee -a $motif_report1
echo "\n\n===== VMStat Summary =====\n\n"  | tee -a $motif_report1
vmstat -s | tee -a $motif_report1
echo "\n\n===== VMStat Process Detail =====\n\n"  | tee -a $motif_report1
vmstat -p 60 5 | tee -a $motif_report1
echo "\n\n===== Reporting report virtual memory statistics =====" | tee -a $motif_report1
vmstat 3 4 >> $motif_report1 | tee -a $motif_report1
echo "\n\n===== Disk IO Statistics iostat -en \n\n" | tee -a $motif_report1
iostat -en | tee -a $motif_report1
echo "\n\n===== Disk Free Space df kh \n"| tee -a $motif_report1
df -kh | tee -a $motif_report1
echo "\n\n===== Disk Free Space df kh \n"| tee -a $motif_report1
du -h / | grep -v '/.*/.*/'
echo "\n\n===== Reporting Disk Activities" | tee -a $motif_report1
/usr/bin/iostat 4 3 | tee -a $motif_report1
echo "\n\n===== Reporting Disk Activities" | tee -a $motif_report1
/usr/bin/iostat -xPnce | tee -a $motif_report1
echo "\n\n===== Reporting Disk Errors" | tee -a $motif_report1
/usr/bin/iostat -En | tee -a $motif_report1
echo "System Activities:"  | tee -a $motif_report1
/usr/bin/sar 5 10  | tee -a $motif_report1
#echo kstat -m cpu_stat | egrep user |idle |kernel |wait  for Solaris 9 and earlier versions %wio wont reported as 0 >> $motif_pm_output
echo "\n\n===== kstat #1" | tee -a $motif_report1
/usr/bin/date  | tee -a $motif_report1
/usr/bin/kstat -m cpu_stat | egrep user |idle |kernel |wait  | tee -a $motif_report1
/usr/bin/sleep 10
echo "\n\n===== kstat #2"  | tee -a $motif_report1
/usr/bin/kstat -m cpu_stat | egrep user |idle |kernel |wait  | tee -a $motif_report1
echo "Network Interface Config" | tee -a $motif_report1
ifconfig -a  | tee -a $motif_report1
# Cancelled because we no longer have Solaris projects that we also maintain networks
# Need to update to handle .bak .orig, etc...
# Check interfaces are plumbed, up and full duplex.
#for iface in `ls /etc/hostname.*|awk '{ FS=".";print $2 }'`
#do
# if dladm show-dev | grep $iface | grep up | grep full > /dev/null
# then
#  echo "Network: $iface is up and full duplex" | tee -a $motif_report1
# else
#  echo "Network: `dladm show-dev | grep $iface`"  | tee -a $motif_report1
# fi
#done
echo "\n\n===== Routing Information =====\n"  | tee -a $motif_report1
netstat -rn  | tee -a $motif_report1
echo "\n\n===== OS Errors - Summary =====\n" | tee -a $motif_report1
echo "==== Panic    " $(grep -ic 'panic' /var/adm/messages)  | tee -a $motif_report1
echo "==== Critical " $(grep -ic 'criti' /var/adm/messages)  | tee -a $motif_report1
echo "==== Error    " $(grep -ic 'error' /var/adm/messages)  | tee -a $motif_report1
echo "==== Fail     " $(grep -ic 'fail' /var/adm/messages)  | tee -a $motif_report1
echo "==== Warn     " $(grep -ic 'warn' /var/adm/messages)  | tee -a $motif_report1
echo "\n\n===== OS Errors - Details =====\n" | tee -a $motif_report1
/usr/bin/grep -i panic /var/adm/me* | tee -a $motif_report1
/usr/bin/grep -i critical /var/adm/me* | tee -a $motif_report1
/usr/bin/grep -i error /var/adm/me* | tee -a $motif_report1
/usr/bin/grep -i fail /var/adm/me* | tee -a $motif_report1
/usr/bin/grep -i warn /var/adm/me* | tee -a $motif_report1
echo "\n\n===== Listing Swap devices:\n" | tee -a $motif_report1
/usr/sbin/swap -l | tee -a $motif_report1
echo "\n\n===== Swap Summary\n" | tee -a $motif_report1
/usr/sbin/swap -s | tee -a $motif_report1
echo "\n\n===== Hot swap pool\n" | tee -a $motif_report1
/usr/sbin/metadb | tee -a $motif_report1
echo "\n\n===== Hot swap pool\n" | tee -a $motif_report1
/usr/sbin/metastat | tee -a $motif_report1
#echo "\n\n===== Reporting Crash Files\n" | tee -a $motif_report1
#echo "===== If you see blank reports, you may not have permission to read the file =====\n" | tee -a $motif_report1
#/usr/bin/ls -lh /var/crash/$(hostname)/  | tee -a $motif_report1
/usr/bin/echo "script has been finished successfully "

