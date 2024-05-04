# Oracle Database Scripts Collection

* **How to drop a scheduled job in Oracle Database?**

Please refer to this [Link.](https://stackoverflow.com/questions/37458051/how-to-drop-a-scheduled-job-in-oracle)

could use this script to drop the jobs.

```
BEGIN
  dbms_scheduler.drop_job(job_name => 'ENTRY_TIME');
END;
/
```

find the job names

```
SELECT * FROM all_scheduler_jobs;
```

find the DB link names

```
SELECT * FROM dba_db_links;
```

find all table names
```
SELECT owner, table_name FROM dba_tables;
```

* **How create a Table and copy the records from Sources Table?**

Please refer to this [Link.](https://stackoverflow.com/questions/233870/how-can-i-create-a-copy-of-an-oracle-table-without-copying-the-data)
```
create table <New-Table-Name> as select * from <Old-Table-Name> where 1=0;

insert into <New-Table-Name> select * from <Old-Table-Name>;
```

* **Oracle Diff: How to compare two Tables?**

Please refer to this [Link.](https://stackoverflow.com/questions/688537/oracle-diff-how-to-compare-two-tables)

Fast Solution:
```
SELECT * FROM TABLE1
MINUS
SELECT * FROM TABLE2
```

Detail Solution:
```
(select * from T1 minus select * from T2) -- all rows that are in T1 but not in T2
union all
(select * from T2 minus select * from T1)  -- all rows that are in T2 but not in T1
;
```

* **How to Find All Tables In An Oracle Database By Column Name?**

Please refer to this [Link.](https://www.thepolyglotdeveloper.com/2015/01/find-tables-oracle-database-column-name/)

```
SELECT * FROM ALL_TAB_COLUMNS
WHERE column_name LIKE '%<Param>%';
```

* **How to print out DBMS_OUTPUT.PUT_LINE values?**

Please refer to this [Link.](https://stackoverflow.com/questions/10434474/dbms-output-put-line-not-printing)

```
SET SERVEROUTPUT ON; 
```

* **How to kill the impdp job in Oracle Database?**

```
impdp attach

// going to DB system, give the username
Username: <schema>/<password>@<ip address>:<port>/<service name>

// checking the job status
Import> status 

// killng the job
Import> kill_job

// and typing [yes] to DB system. it will be killed.

```

* **How to check the impdp job is running in Oracle Database?**

Search this table, and you can find the job name and operation, etc.
```
select * from DBA_DATAPUMP_JOBS;

```