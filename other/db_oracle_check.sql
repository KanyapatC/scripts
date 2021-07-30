-- Dictionary Integrity CHECK
spool /export/home/approot/dbms_check_20170930.txt
-- dbms_hm  doest not exists in production, skip these
-- exec DBMS_HM.RUN_CHECK('Dictionary Integrity Check', 'hm_20150918_1000_dict');
-- exec DBMS_HM.RUN_CHECK('DB Structure Integrity Check', 'hm_20150918_1000_dbstr');

-- get report
set LONG 10000
set LONGCHUNKSIZE 10000
set PAGESIZE 1000
set LINESIZE 512
set colsep ^

-- get report on database structure
select dbms_hm.get_run_report('hm_20150918_1000_dict','TEXT','BASIC') from dual;
select dbms_hm.get_run_report('hm_20150918_1000_dbstr','TEXT','BASIC') from dual;

SELECT '                                                  ' as "Log Queries (5 secs)" from dual;
select sql_id , rows_processed, command_type, optimizer_cost, cpu_time, elapsed_time, last_active_time, sql_fulltext FROM v$SQL WHERE decode(executions,0,0,elapsed_time/executions) > 5000000 order by elapsed_time desc;


-- List tablespaces
SELECT '                                                  ' as "Tablespace list" from dual;
SELECT tablespace_name, block_size, initial_extent, next_extent, min_extents, max_extents, max_size, pct_increase, min_extlen, status, contents, logging, force_logging, extent_management, allocation_type, plugged_in, segment_space_management, def_tab_compression, retention, bigfile, predicate_evaluation FROM dba_tablespaces;

-- Check the size of data files
SELECT '                                                  ' as "Data files size" from dual;
SELECT file_id, tablespace_name,bytes,blocks,status,relative_fno, autoextensible, maxbytes, maxblocks, increment_by, user_bytes, user_blocks, online_status  FROM dba_data_files;

-- file usage 
SELECT '                                                  ' as "Data files usage" from dual;
SELECT tablespace_name, header_file, owner, segment_type, sum(bytes)/(1024*1024) as size_mb, sum(blocks) from dba_segments group by owner, segment_type, tablespace_name, header_file, owner order by tablespace_name, header_file;

-- Archive Log Mode
SELECT '                                                  ' as "Archive Log mode" from dual;
archive log list;

-- Recovery Area usage
SELECT '                                                  ' as "Recovery Area usage" from dual;
SELECT NAME, TO_CHAR(SPACE_LIMIT, '999,999,999,999') AS SPACE_LIMIT, TO_CHAR(SPACE_LIMIT - SPACE_USED + SPACE_RECLAIMABLE, '999,999,999,999') AS SPACE_AVAILABLE, ROUND((SPACE_USED - SPACE_RECLAIMABLE)/SPACE_LIMIT * 100, 1) AS PERCENT_FULL FROM V$RECOVERY_FILE_DEST;


-- Check if tables are updated to provide best query performance
SELECT '                                                  ' as "Table Statistics" from dual;
Select table_name , num_rows from dba_tables where owner IN ('BAFS', 'BILLING') order by table_name;

SELECT '                                                  ' as "Index Statistics" from dual;
Select index_name , index_type, table_owner, owner, table_type, uniqueness, distinct_keys, num_rows, sample_size, last_analyzed from dba_indexes where table_owner IN ('BAFS','BILLING') order by table_name, index_name;

SELECT '                                                  ' as "Index Columns" from dual;
Select index_owner || '^' || index_name || '^' || table_owner || '^' || table_name || '^' || column_name || '^' || column_position from all_ind_columns where table_owner IN ('BAFS','BILLING');

-- Also if there are any suspects or if you have time, validate each table
select '                               ' as "Analysing RP_REPORT_TXN" FROM DUAL;
ANALYZE TABLE MAS.RP_REPORT_TXN VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing RP_REPORT_SUPPLIER" FROM DUAL;
 ANALYZE TABLE MAS.RP_REPORT_SUPPLIER VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing RP_REPORT" FROM DUAL;
ANALYZE  TABLE MAS.RP_REPORT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing RP_EVENT_LOG" FROM DUAL;
 ANALYZE TABLE MAS.RP_EVENT_LOG VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing PLAN_TABLE" FROM DUAL;
 ANALYZE TABLE MAS.PLAN_TABLE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_USER_PERM" FROM DUAL;
 ANALYZE TABLE MAS.IP_US_USER_PERM VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_USER_GROUP" FROM DUAL;
 ANALYZE TABLE MAS.IP_US_USER_GROUP VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_USER_CHANL" FROM DUAL;
 ANALYZE TABLE MAS.IP_US_USER_CHANL VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_USER_ATTR" FROM DUAL;
 ANALYZE TABLE MAS.IP_US_USER_ATTR VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_USER" FROM DUAL;
 ANALYZE TABLE MAS.IP_US_USER VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_PERM" FROM DUAL;
ANALYZE  TABLE MAS.IP_US_PERM VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_OLD_PWD" FROM DUAL;
ANALYZE  TABLE MAS.IP_US_OLD_PWD VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_GROUP_UPPER" FROM DUAL;
ANALYZE  TABLE MAS.IP_US_GROUP_UPPER VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_GROUP_SUBGRP" FROM DUAL;
 ANALYZE TABLE MAS.IP_US_GROUP_SUBGRP VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_GROUP_PERM" FROM DUAL;
ANALYZE  TABLE MAS.IP_US_GROUP_PERM VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_GROUP" FROM DUAL;
 ANALYZE TABLE MAS.IP_US_GROUP VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_DELEG_USER" FROM DUAL;
ANALYZE  TABLE MAS.IP_US_DELEG_USER VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_DELEG_PERM" FROM DUAL;
 ANALYZE TABLE MAS.IP_US_DELEG_PERM VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_CHANL" FROM DUAL;
 ANALYZE TABLE MAS.IP_US_CHANL VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing IP_US_ATTR" FROM DUAL;
 ANALYZE TABLE MAS.IP_US_ATTR VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_YEAR_TXN" FROM DUAL;
 ANALYZE TABLE MAS.FZ_YEAR_TXN VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_UPDATE_STOCK" FROM DUAL;
 ANALYZE TABLE MAS.FZ_UPDATE_STOCK VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_SUPPLIER_LIMIT_DETAIL" FROM DUAL;
 ANALYZE TABLE MAS.FZ_SUPPLIER_LIMIT_DETAIL VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_SUPPLIER_LIMIT" FROM DUAL;
 ANALYZE TABLE MAS.FZ_SUPPLIER_LIMIT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_RATE" FROM DUAL;
 ANALYZE TABLE MAS.FZ_RATE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_MONTH_TXN" FROM DUAL;
 ANALYZE TABLE MAS.FZ_MONTH_TXN VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_IMPORT_ONTRUCK" FROM DUAL;
 ANALYZE TABLE MAS.FZ_IMPORT_ONTRUCK VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_GAIN_LOSS" FROM DUAL;
 ANALYZE TABLE MAS.FZ_GAIN_LOSS VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_FACTOR" FROM DUAL;
 ANALYZE TABLE MAS.FZ_FACTOR VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_DR_TRUCK_IMPORT_FAIL" FROM DUAL;
 ANALYZE TABLE MAS.FZ_DR_TRUCK_IMPORT_FAIL VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_DR_TRUCK" FROM DUAL;
 ANALYZE TABLE MAS.FZ_DR_TRUCK VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_DR_STATUS" FROM DUAL;
 ANALYZE TABLE MAS.FZ_DR_STATUS VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_DELIVERY_TXN_IMPORT_FAIL" FROM DUAL;
 ANALYZE TABLE MAS.FZ_DELIVERY_TXN_IMPORT_FAIL VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_DELIVERY_TXN " FROM DUAL;
ANALYZE  TABLE MAS.FZ_DELIVERY_TXN VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_DELIVERY_REMAIN_DETAIL" FROM DUAL;
ANALYZE  TABLE MAS.FZ_DELIVERY_REMAIN_DETAIL VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_DELIVERY_REMAIN" FROM DUAL;
ANALYZE  TABLE MAS.FZ_DELIVERY_REMAIN VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_DEADSTOCK" FROM DUAL;
ANALYZE  TABLE MAS.FZ_DEADSTOCK VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_DATE_STOCK" FROM DUAL;
ANALYZE  TABLE MAS.FZ_DATE_STOCK VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_CONTRACT_RATE" FROM DUAL;
 ANALYZE TABLE MAS.FZ_CONTRACT_RATE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing FZ_CONTRACT" FROM DUAL;
 ANALYZE TABLE MAS.FZ_CONTRACT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing DZ_TRANSFER_NOTE" FROM DUAL;
 ANALYZE TABLE MAS.DZ_TRANSFER_NOTE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing DZ_TANK_MEASURE_DETAIL" FROM DUAL;
 ANALYZE TABLE MAS.DZ_TANK_MEASURE_DETAIL VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing DZ_TANK_MEASURE" FROM DUAL;
 ANALYZE TABLE MAS.DZ_TANK_MEASURE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing DZ_SENDER_TANK" FROM DUAL;
 ANALYZE TABLE MAS.DZ_SENDER_TANK VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing DZ_PRODUCT_DELIVERY" FROM DUAL;
 ANALYZE TABLE MAS.DZ_PRODUCT_DELIVERY VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing DZ_DEL_TANK_PROP" FROM DUAL;
 ANALYZE TABLE MAS.DZ_DEL_TANK_PROP VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing DZ_DEL_TANK_MEASURE_RULE_ITEM" FROM DUAL;
ANALYZE  TABLE MAS.DZ_DEL_TANK_MEASURE_RULE_ITEM VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing DZ_DEL_TANK_MEASURE_RULE" FROM DUAL;
 ANALYZE TABLE MAS.DZ_DEL_TANK_MEASURE_RULE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing DZ_DEL_TANK_MEASURE" FROM DUAL;
 ANALYZE TABLE MAS.DZ_DEL_TANK_MEASURE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing DZ_DEL_TANK_API" FROM DUAL;
 ANALYZE TABLE MAS.DZ_DEL_TANK_API VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_UPDATE_SUMMARY" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_UPDATE_SUMMARY VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_RELEASE_REPORT" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_RELEASE_REPORT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_FZ_DR_TRUCK" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_FZ_DR_TRUCK VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_FZ_DELIVERY_TXN" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_FZ_DELIVERY_TXN VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_FZ_DELIVERY_REMAIN_DT" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_FZ_DELIVERY_REMAIN_DT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_FZ_DELIVERY_REMAIN" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_FZ_DELIVERY_REMAIN VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_DZ_TRANSFER_NOTE" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_DZ_TRANSFER_NOTE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_DZ_TANK_MEASURE_DETAIL" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_DZ_TANK_MEASURE_DETAIL VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_DZ_TANK_MEASURE" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_DZ_TANK_MEASURE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_DZ_SENDER_TANK" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_DZ_SENDER_TANK VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_DZ_PRODUCT_DELIVERY" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_DZ_PRODUCT_DELIVERY VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_DZ_DEL_TANK_PROP" FROM DUAL;
ANALYZE  TABLE MAS.ARCH_DZ_DEL_TANK_PROP VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_DZ_DEL_TANK_MEASURE" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_DZ_DEL_TANK_MEASURE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_DZ_DEL_TANK_API" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_DZ_DEL_TANK_API VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing ARCH_APPROVAL" FROM DUAL;
 ANALYZE TABLE MAS.ARCH_APPROVAL VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_USER_PROP" FROM DUAL;
 ANALYZE TABLE MAS.AD_USER_PROP VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_UNIT_CONVERSION" FROM DUAL;
 ANALYZE TABLE MAS.AD_UNIT_CONVERSION VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_TSF_PROP" FROM DUAL;
 ANALYZE TABLE MAS.AD_TSF_PROP VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_TSF" FROM DUAL;
 ANALYZE TABLE MAS.AD_TSF VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_TRUCK" FROM DUAL;
 ANALYZE TABLE MAS.AD_TRUCK VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_TRAVEL_FEE" FROM DUAL;
 ANALYZE TABLE MAS.AD_TRAVEL_FEE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_TANK_PROP" FROM DUAL;
 ANALYZE TABLE MAS.AD_TANK_PROP VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_TANK" FROM DUAL;
ANALYZE  TABLE MAS.AD_TANK VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_TABLE6B" FROM DUAL;
 ANALYZE TABLE MAS.AD_TABLE6B VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_TABLE53B" FROM DUAL;
 ANALYZE TABLE MAS.AD_TABLE53B VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_SUPPLIER_SOURCE" FROM DUAL;
 ANALYZE TABLE MAS.AD_SUPPLIER_SOURCE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_SUPPLIER_ROUTE" FROM DUAL;
 ANALYZE TABLE MAS.AD_SUPPLIER_ROUTE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_SUPPLIER" FROM DUAL;
 ANALYZE TABLE MAS.AD_SUPPLIER VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_SHIPPER" FROM DUAL;
 ANALYZE TABLE MAS.AD_SHIPPER VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_SALE_TERM" FROM DUAL;
 ANALYZE TABLE MAS.AD_SALE_TERM VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_PRODUCT" FROM DUAL;
 ANALYZE TABLE MAS.AD_PRODUCT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_NEWS_TARGET" FROM DUAL;
 ANALYZE TABLE MAS.AD_NEWS_TARGET VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_NEWS" FROM DUAL;
 ANALYZE TABLE MAS.AD_NEWS VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_MAX_LOSS_GAIN" FROM DUAL;
 ANALYZE TABLE MAS.AD_MAX_LOSS_GAIN VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_LEVEL_VOLUME_DETAIL" FROM DUAL;
 ANALYZE TABLE MAS.AD_LEVEL_VOLUME_DETAIL VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_LEVEL_VOLUME" FROM DUAL;
 ANALYZE TABLE MAS.AD_LEVEL_VOLUME VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_IMPORT_OFFLINE" FROM DUAL;
 ANALYZE TABLE MAS.AD_IMPORT_OFFLINE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_EXTRA_FEE" FROM DUAL;
 ANALYZE TABLE MAS.AD_EXTRA_FEE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_EFFECTIVE_DATE" FROM DUAL;
 ANALYZE TABLE MAS.AD_EFFECTIVE_DATE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_DESTINATION" FROM DUAL;
 ANALYZE TABLE MAS.AD_DESTINATION VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_DELIVERY_AGENCY" FROM DUAL;
 ANALYZE TABLE MAS.AD_DELIVERY_AGENCY VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_DEADSTOCK_TYPE" FROM DUAL;
 ANALYZE TABLE MAS.AD_DEADSTOCK_TYPE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_BANK_ACCOUNT" FROM DUAL;
 ANALYZE TABLE MAS.AD_BANK_ACCOUNT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_APPROVAL" FROM DUAL;
 ANALYZE TABLE MAS.AD_APPROVAL VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_API_DENSITY" FROM DUAL;
 ANALYZE TABLE MAS.AD_API_DENSITY VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_AIRPORT_BRANCH" FROM DUAL;
 ANALYZE TABLE MAS.AD_AIRPORT_BRANCH VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_AIRLINE" FROM DUAL;
 ANALYZE TABLE MAS.AD_AIRLINE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing AD_AIRCRAFT" FROM DUAL;
 ANALYZE TABLE MAS.AD_AIRCRAFT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_TRANSACTION_PROC" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_TRANSACTION_PROC VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_SERVICE_FEE" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_SERVICE_FEE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_PARAMETER" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_PARAMETER VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_MINIMUM_CHARGE" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_MINIMUM_CHARGE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_INVOICE_RATE" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_INVOICE_RATE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_INVOICE_MINIMUM_CHARGE" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_INVOICE_MINIMUM_CHARGE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_INVOICE_MANUAL_REMARK" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_INVOICE_MANUAL_REMARK VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_INVOICE_MANUAL" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_INVOICE_MANUAL VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_INVOICE_DISCOUNT" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_INVOICE_DISCOUNT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_INVOICE_CONTRACT_DR" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_INVOICE_CONTRACT_DR VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_INVOICE_CONTRACT" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_INVOICE_CONTRACT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_INVOICE" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_INVOICE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_FLIGHT_SCHEDULE" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_FLIGHT_SCHEDULE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_FLIGHT" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_FLIGHT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_EXCHANGE_RATE" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_EXCHANGE_RATE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_DISCOUNT" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_DISCOUNT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_CONTRACT_TRANSACTION" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_CONTRACT_TRANSACTION VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_CONTRACT_RATE" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_CONTRACT_RATE VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_CONTRACT_FLIGHT" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_CONTRACT_FLIGHT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_CONTRACT_DR" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_CONTRACT_DR VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_CONTRACT" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_CONTRACT VALIDATE STRUCTURE CASCADE;
select '                               ' as "Analysing BZ_ACF_DR" FROM DUAL;
 ANALYZE TABLE BILLING.BZ_ACF_DR VALIDATE STRUCTURE CASCADE;


-- If you ever found any failures, First try this in RMAN
-- LIST FAILURE;
-- or better, get FAILURE id and available options from RMAN
-- ADVISE FAILURE; 
-- REPAIR FAILURE [USING ADVISE OPTIONS] [PREVIEW]

spool off
