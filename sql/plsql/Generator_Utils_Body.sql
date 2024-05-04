--------------------------------------------------------
--  File created - Tuesday-April-30-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body GENERATOR_UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GENERATOR_UTILS" AS

    FUNCTION checkIfTableOrViewExists(pTbl in varchar2) RETURN NUMBER IS
        table_counter_value    NUMBER;
    BEGIN
        SELECT count(1) INTO table_counter_value
        FROM USER_TABLES 
        WHERE TABLE_NAME = pTbl;

        RETURN table_counter_value;
    END;

    PROCEDURE generate_inserts_by_table_name(pTableName in varchar2) is
    BEGIN        
            generate_inserts_with_output_line(pTableName);
    END;

    PROCEDURE generate_inserts_with_output_line(pTbl in varchar2) is
    BEGIN
        DBMS_OUTPUT.ENABLE();
        DBMS_OUTPUT.PUT_LINE('prompt Importing table '||pTbl||'...');
        DBMS_OUTPUT.PUT_LINE('DELETE');
        DBMS_OUTPUT.PUT_LINE('from '||pTbl||';');
        DBMS_OUTPUT.PUT_LINE(' '); 
        generate_inserts(pTbl);
        DBMS_OUTPUT.PUT_LINE(' '); 
        DBMS_OUTPUT.PUT_LINE('prompt Done.');
        DBMS_OUTPUT.PUT_LINE('commit;');
        DBMS_OUTPUT.PUT_LINE(' '); 
    END;

    PROCEDURE generate_inserts(pTbl in varchar2) is
        v_inserttxt VARCHAR2(4000);
        v_datatxt   VARCHAR2(4000);  
        v_v_val     VARCHAR2(4000);
        v_n_val     NUMBER;
        v_d_val     DATE;
        v_ret       NUMBER;
        c           NUMBER;
        d           NUMBER;
        col_cnt     INTEGER;
        f           BOOLEAN;
        rec_tab     DBMS_SQL.DESC_TAB;
        col_num     NUMBER;
        l_file UTL_FILE.FILE_TYPE;
    BEGIN
        l_file := UTL_FILE.FOPEN('EXTRACT_DIR', pTbl || '.sql', 'A');
        c := DBMS_SQL.OPEN_CURSOR;
        DBMS_SQL.PARSE(c, 'select * from '||pTbl, DBMS_SQL.NATIVE);
        d := DBMS_SQL.EXECUTE(c);
        DBMS_SQL.DESCRIBE_COLUMNS(c, col_cnt, rec_tab);
        -- Bind variables to columns
        FOR j in 1..col_cnt
        LOOP
            CASE rec_tab(j).col_type
                WHEN 1 THEN DBMS_SQL.DEFINE_COLUMN(c,j,v_v_val,2000);
                WHEN 2 THEN DBMS_SQL.DEFINE_COLUMN(c,j,v_n_val);
                WHEN 12 THEN DBMS_SQL.DEFINE_COLUMN(c,j,v_d_val);
            ELSE
            DBMS_SQL.DEFINE_COLUMN(c,j,v_v_val,2000);
            END CASE;
        END LOOP;
        -- This part generates the insert columns
            v_inserttxt := NULL;
        for j in 1..col_cnt
        LOOP
            v_inserttxt := ltrim(v_inserttxt||','||lower(rec_tab(j).col_name),',');
        END LOOP;
            v_inserttxt := 'insert into '||pTbl||' ('||v_inserttxt||') values (';
        -- This part outputs the DATA
        LOOP
            v_ret := DBMS_SQL.FETCH_ROWS(c);
            EXIT WHEN v_ret = 0;
            v_datatxt := null;
        FOR j in 1..col_cnt
            LOOP
            CASE rec_tab(j).col_type
                WHEN 1 THEN DBMS_SQL.COLUMN_VALUE(c,j,v_v_val);
                    v_datatxt := v_datatxt || 
                    case when j > 1 then ',' 
                    else '' end||''''||REPLACE(v_v_val,'''','''''')||'''';
                WHEN 2 THEN DBMS_SQL.COLUMN_VALUE(c,j,v_n_val);
                    v_datatxt := v_datatxt ||
                    case when j > 1 then ',' 
                    else '' end||nvl(to_char(v_n_val),'NULL');
                WHEN 12 THEN DBMS_SQL.COLUMN_VALUE(c,j,v_d_val);
                    v_datatxt := v_datatxt ||
                    case when j > 1 then ',' 
                    else '' end ||
            case when v_d_val is null then 'NULL' 
                else 'to_date('''||to_char(v_d_val,'YYYYMMDDHH24MISS')||''',''YYYYMMDDHH24MISS'')' end;
            ELSE
                DBMS_SQL.COLUMN_VALUE(c,j,v_v_val);
                v_datatxt := v_datatxt||case when j > 1 then ',' else '' end||''''||v_v_val||'''';
            END CASE;
            END LOOP;
        DBMS_OUTPUT.ENABLE();
        DBMS_OUTPUT.PUT_LINE(v_inserttxt||v_datatxt||');');
        UTL_FILE.PUT_LINE(l_file, v_inserttxt||v_datatxt||');');
        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(c);
    END;

END GENERATOR_UTILS;

/
