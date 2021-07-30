spool /export/home/approot/motif_pm/scripts/db_queryhist.txt
set LONG 10000
set LONGCHUNKSIZE 10000
set PAGESIZE 1000
set LINESIZE 512
set COLSEP ^

select '===============================' as slow_sql_5s from dual;
select replace(replace(sql_fulltext,chr(13),' '),chr(10),' ') as sql_text, sql_id, rows_processed, command_type, optimizer_cost, cpu_time, elapsed_time, last_active_time, application_wait_time, concurrency_wait_time, user_io_wait_time, plsql_exec_time, java_exec_time, sharable_mem, persistent_mem, sorts, fetches, executions, buffer_gets, rows_processed, optimizer_mode, last_load_time FROM v$SQL WHERE executions>0 AND elapsed_time > 5000000 order by elapsed_time desc;

SELECT '===============================' AS sql_plan_section FROM dual;
SELECT * FROM v$sql_plan WHERE sql_id IN (SELECT sql_id FROM v$SQL WHERE executions > 0 AND elapsed_time/executions > 5000000);
 
select '===============================' as table_list  from dual;
Select table_name || '^' || num_rows from dba_tables where owner IN ('BAFS', 'BILLING') order by table_name;

select '===============================' as index_list from dual;
Select index_name || '^' || index_type || '^' || table_owner || '^' || owner || '^' || table_name || '^' || table_Type || '^' || uniqueness || '^' || distinct_keys || '^' || num_rows || '^' || sample_size || '^' || last_analyzed as index_data from dba_indexes where table_owner IN ('BAFS','BILLING') order by table_name, index_name;

select '===============================' as index_columns from dual;
Select index_owner || '^' || index_name || '^' || table_owner || '^' || table_name || '^' || column_name || '^' || column_position as index_data from all_ind_columns where table_owner IN ('BAFS','BILLING');

-- List tablespaces
SELECT '                                                  ' as "Tablespace list" from dual;
SELECT tablespace_name, block_size, initial_extent, next_extent, min_extents, max_extents, max_size, pct_increase, min_extlen, status, contents, logging, force_logging, extent_ma
nagement, allocation_type, plugged_in, segment_space_management, def_tab_compression, retention, bigfile, predicate_evaluation FROM dba_tablespaces;

-- Check the size of data files
SELECT '                                                  ' as "Data files size" from dual;
SELECT file_id, tablespace_name,bytes,blocks,status,relative_fno, autoextensible, maxbytes, maxblocks, increment_by, user_bytes, user_blocks, online_status  FROM dba_data_files;

-- file usage 
SELECT '                                                  ' as "Data files usage" from dual;
SELECT tablespace_name, header_file, owner, segment_type, sum(bytes)/(1024*1024) as size_mb, sum(blocks) from dba_segments group by owner, segment_type, tablespace_name, header_f
ile, owner order by tablespace_name, header_file;

-- Archive Log Mode
SELECT '                                                  ' as "Archive Log mode" from dual;
archive log list;

-- Recovery Area usage
SELECT '                                                  ' as "Recovery Area usage" from dual;
SELECT NAME, TO_CHAR(SPACE_LIMIT, '999,999,999,999') AS SPACE_LIMIT, TO_CHAR(SPACE_LIMIT - SPACE_USED + SPACE_RECLAIMABLE, '999,999,999,999') AS SPACE_AVAILABLE, ROUND((SPACE_USE
D - SPACE_RECLAIMABLE)/SPACE_LIMIT * 100, 1) AS PERCENT_FULL FROM V$RECOVERY_FILE_DEST;


-- Check if tables are updated to provide best query performance
SELECT '                                                  ' as "Table Statistics" from dual;
Select table_name , num_rows from dba_tables where owner IN ('BAFS', 'BILLING') order by table_name;

SELECT '                                                  ' as "Index Columns" from dual;
Select index_owner || '^' || index_name || '^' || table_owner || '^' || table_name || '^' || column_name || '^' || column_position from all_ind_columns where table_owner IN ('BAF
S',eBILLING');


SELECT '==================================' as "db_cache_advice";
SELECT * FROM v$DB_CACHE_ADVICE;
 
show parameter;

-- report on database structure
select dbms_hm.get_run_report('hm_20171209_1000_dict','TEXT','BASIC') from dual;
select dbms_hm.get_run_report('hm_20171209_1000_dbstr','TEXT','BASIC') from dual;




spool off
