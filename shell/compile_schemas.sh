#!/bin/bash
#
# Please update the below variable for this script
# $1: schema name

clear

export JAVA_HOME=<java_home>
export ORACLE_HOME=<oracle_home>
export PATH=$PATH:$JAVA_HOME/bin:$ORACLE_HOME/bin

echo $JAVA_HOME
echo $ORACLE_HOME
echo $PATH

DATE=`date +%Y%m%d_%H%M%S`
LOG_FILE="compile_log${DATE}.log"

function compile_schema() {
	echo "invoke DBMS_UTILITY to compile the invalids.."
	echo "compiling for shema: $1"

# 1. invoke DBMS_UTILITY.compile_schema
# 2. print the invalid number
$ORACLE_HOME/bin/sqlplus -s <<EOF>> $1$LOG_FILE $1/<pass-word>@<ip-address>:<port>/<service-name>

	set serveroutput on;

	DECLARE
		b_sql varchar2(300);
		a_sql varchar2(300);
		before number;
		after number;
	BEGIN

		b_sql := 'select count(1) from user_objects where status = ''INVALID''';          
		EXECUTE IMMEDIATE b_sql INTO before;
		dbms_output.put_line('$1 before invalids: ' || before);
	
		DBMS_UTILITY.compile_schema('$1', FALSE);
	
		a_sql := 'select count(1) from user_objects where status = ''INVALID''';          
		EXECUTE IMMEDIATE a_sql INTO after;
		dbms_output.put_line('$1 after invalids: ' || after);
	END;
	/
EOF

echo "compiling for shema: $1 finished!"
}

# below scope is our operation parameters settings
# put the schemas here.
# e.g compile_schema <schema>




