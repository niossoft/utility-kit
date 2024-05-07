--------------------------------------------------------
--  File created - Tuesday-April-30-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package GENERATOR_UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GENERATOR_UTILS" AS

    FUNCTION checkIfTableOrViewExists(pTbl in varchar2) RETURN NUMBER;

    PROCEDURE generate_inserts(pTbl in varchar2);
    PROCEDURE generate_inserts_with_output_line(pTbl in varchar2);
	  PROCEDURE generate_inserts_by_table_name(pTableName in varchar2);

    PROCEDURE generate_updates(pTbl in varchar2);

    --PROCEDURE export_inserts_file(pFileName in varchar2);

END GENERATOR_UTILS;

/
