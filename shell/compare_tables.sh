#!/bin/bash

export JAVA_HOME=<java_home>
export ORACLE_HOME=<oracle_home>
export PATH=$PATH:$JAVA_HOME/bin:$ORACLE_HOME/bin

echo $JAVA_HOME
echo $ORACLE_HOME
echo $PATH

#(DESCRIPTION=
#  (ADDRESS=(PROTOCOL=tcp)(HOST=sales-server)(PORT=1521))
#  (CONNECT_DATA=
#     (SID=sales)
#     (SERVICE_NAME=sales.us.example.com)
#     (INSTANCE_NAME=sales))
#     (SERVER=shared)))
#)

# Database connection details (replace with yours)
# Source Database
SRC_DB_USER="source_user"
SRC_DB_PASS="source_password"
SRC_SCHEMA="source_schema"  # Include schema name if applicable
SRC_TABLE="source_table"
SRC_TNS="(DESCRIPTION=...)"  # TNS connection string

# Target Database
TGT_DB_USER="target_user"
TGT_DB_PASS="target_password"
TGT_SCHEMA="target_schema"  # Include schema name if applicable
TGT_TABLE="target_table"
TGT_TNS="(DESCRIPTION=...)"  # TNS connection string

# Temporary files for data and schema export
TMP_SCHEMA_FILE="/tmp/table_schema.sql"
TMP_DATA_FILE="/tmp/table_data.csv"

# Function to check for errors and exit
check_error() {
  if [ $? -ne 0 ]; then
    echo "Error: $1"
    exit 1
  fi
}

# Export table schema from source database
$ORACLE_HOME/bin/sqlplus -s <<EOF>> $1$LOG_FILE $1/<pass-word>@<ip-address>:<port>/<service-name>
$ORACLE_HOME/bin/sqlplus -s ${SRC_DB_USER}/${SRC_DB_PASS}@${SRC_TNS} <<EOF
  SET HEAD OFF
  SET FEEDBACK OFF
  SPOOL $TMP_SCHEMA_FILE
  SELECT DBMS_METADATA.GET_DDL('TABLE', '${SRC_TABLE}') FROM DUAL;
  SPOOL OFF
  EXIT;
EOF

check_error "Exporting table schema from source"

# Import schema (excluding data) into temporary table in target database
$ORACLE_HOME/bin/sqlplus -s ${TGT_DB_USER}/${TGT_DB_PASS}@${TGT_TNS} <<EOF
  @${TMP_SCHEMA_FILE}  -- Execute the exported schema

  COMMIT;
  EXIT;
EOF

check_error "Importing schema into target database"

# Export data from source table
$ORACLE_HOME/bin/sqlplus -s ${SRC_DB_USER}/${SRC_DB_PASS}@${SRC_TNS} <<EOF
  SET HEAD OFF
  SET FEEDBACK OFF
  SPOOL $TMP_DATA_FILE
  SELECT * FROM ${SRC_SCHEMA}.${SRC_TABLE};  -- Include schema if applicable
  SPOOL OFF
  EXIT;
EOF

check_error "Exporting data from source table"

# Import data into temporary table in target database
$ORACLE_HOME/bin/sqlplus -s ${TGT_DB_USER}/${TGT_DB_PASS}@${TGT_TNS} <<EOF
  SET HEAD OFF
  SET FEEDBACK OFF

  BULK COLLECT INTO TEMP_TABLE
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
  FROM '${TMP_DATA_FILE}';

  EXIT;
EOF

check_error "Importing data into target database"

# Compare table structure (excluding data)
echo "Comparing table structure..."
diff <($ORACLE_HOME/bin/sqlplus -s ${SRC_DB_USER}/${SRC_DB_PASS}@${SRC_TNS} <<EOF
  DESCRIBE ${SRC_SCHEMA}.${SRC_TABLE};  -- Include schema if applicable
  EXIT;
EOF) <($ORACLE_HOME/bin/sqlplus -s ${TGT_DB_USER}/${TGT_DB_PASS}@${TGT_TNS} <<EOF
  DESCRIBE TEMP_TABLE;
  EXIT;
EOF)

# Compare table data using minus operator
echo "Comparing table data (rows with different values)..."
$ORACLE_HOME/bin/sqlplus -s ${TGT_DB_USER}/${TGT_DB_PASS}@${TGT_TNS} <<EOF
  SELECT * FROM TEMP_TABLE
  MINUS
  SELECT * FROM ${TGT_SCHEMA}.${TGT_TABLE};  -- Include schema if applicable
  EXIT;
EOF

# Clean up temporary files
rm -f $TMP_SCHEMA_FILE $TMP_DATA_FILE

echo "Schema and data comparison completed."

