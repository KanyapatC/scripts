@echo off
echo.
echo ****************************************************************************************
echo ******************* Semi-automated test script for window server 2016 ******************
echo *****************************  Motif Technology Plc.  **********************************
echo ******************* Revision 04 - 2018-10-06 by Wittaya.w,Kanyapat.c *******************
echo ****************************************************************************************
echo.

rem Setting variables. Pleae make sure you do update this every time.


echo "====================== Preventive Maintenance Report =======================" 
echo.

@ SET motif_report_home=cd;%cd%
@ SET motif_file_sysinfo=%cd%\sysinfo.txt 
echo "============================ System Information ============================"
echo = Currently not automated. Please take the output files and make report to  =
echo = customer yourself. Sorry.OS Information                                   =
echo =============================================================================
echo.
echo "==================== Operating System ID successfully ======================" 
     systeminfo  >> %motif_file_sysinfo% 
echo.
echo "========================= Host name successfully ===========================" 
     hostname >> %motif_file_sysinfo% 
	 echo.
echo "======================== Host Uptime successfully ==========================" 
     systeminfo|find "Time:" >> %motif_file_sysinfo% 
	 net stats workstation >> %motif_file_sysinfo%
echo.
echo "======================= Login Attempts successfully ========================"  
     query user >>  %motif_file_sysinfo%
echo.

@ SET motif_file_process=%cd%\process.txt 
echo.
echo ====================== 2 CPU and Process Information =========================
echo = There is no blacklisted processes yet. Please check and identified         =
echo = dubious process manually for the time being. for the time being.           =                      
echo ==============================================================================
echo.
echo "=========== Reporting Process Resource Statistics successfully ==============" 
	 wmic MEMORYCHIP get BankLabel, DeviceLocator, MemoryType, TypeDetail, Capacity, Speed >> %motif_file_process% 
	 wmic cpu get caption, deviceid, name, numberofcores, maxclockspeed, status >> %motif_file_process%
	 wmic os get freephysicalmemory, freevirtualmemory >> %motif_file_process% 
echo.
echo "============ Reporting Task service list Statistics successfully ============" 
	tasklist >> %motif_file_process%	 
echo.
echo "====== Reporting Task service CPU% and RAM usage for all successfully =======" 
	tasklist /V >> %motif_file_process%	 
echo.
echo "============= Check Paging Memory on swap for Windows successfully ===========" 
	 systeminfo | find "Virtual Memory" >> %motif_file_process%	
	 echo.
echo ====================== Diagnosis Disk Statistics ==============================
echo = There is no blacklisted processes yet. Please check and identified dubious  =
echo = process manually for the time being. 					                   =
echo ===============================================================================
echo.

@ SET motif_file_storage=%cd%\storage.txt
echo.
echo "===================== Check Disk Statistics successfully ======================" 
	 chkdsk >> %motif_file_storage%  
echo.
echo "======================= Disk I/O Statistics successfully ======================" 
	 wmic path Win32_PerfRawData_PerfDisk_PhysicalDisk get Name,DiskWriteBytesPerSec,DiskReadBytesPerSec,Timestamp_PerfTime >> %motif_file_storage%
echo.
echo "======================== Disk Free Space successfully ========================="
	 wmic logicaldisk get size,freespace,caption >> %motif_file_storage% 
echo.

echo ======================= Diagnosis Network Configuration ========================
echo = There is no blacklisted processes yet. Please check and identified dubious   =
echo = process manually for the time being. 					                    =					  
echo ================================================================================
echo.

@ SET motif_file_network=%cd%\network.txt
echo.
echo "=================== Network Interface Config successfully ====================="
	 ipconfig /all  >> %motif_file_network% 
echo.
echo "====================== Routing Information successfully ======================="
	 netstat -rn  >> %motif_file_network% 
echo.
echo.
echo >>>>>>>>>>>>>>> "script has been finished successfully all " <<<<<<<<<<<<<<<<<<<<
echo.
pause
