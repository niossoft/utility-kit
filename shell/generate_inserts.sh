#!/bin/bash
#
# Please update the below variable for this script
# $1: schema name
# $2: table name

export JAVA_HOME=<java_home>
export ORACLE_HOME=<oracle_home>
export PATH=$PATH:$JAVA_HOME/bin:$ORACLE_HOME/bin

SQL_FILE=$1.sql

function generate_inserts_by_table_name() {

echo "invoke generator_utils to extract for function: $2 in $1 schema.."

$ORACLE_HOME/bin/sqlplus -s <<EOF>> $2.sql $1/<pass-word>@<ip-address>:<port>/<service-name>
	set linesize 4000;
	set serveroutput on;
	exec generator_utils.generate_inserts_by_table_name('$2');
	/
EOF

echo "extract for function: $2 in $1 schema finished!"
}
