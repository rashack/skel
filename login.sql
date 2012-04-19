col name_col_plus_show_param format a40
col value_col_plus_show_param format a70

col plan_plus_exp format a120
set linesize 200
set pagesize 100
set serveroutput on size 1000000
col Name format a20
set numwidth 16

set feedback off
set head off
set termout off

alter session set nls_date_format = 'YYYY-MM-DD hh24:MI:SS';
col luser new_value uname
select lower(user) luser from dual;
col hn new_value hname
select host_name hn from v$instance;
def promptstr=[33m&uname..&_connect_identifier[m
def hostname=[44m[@&hname][m

set termout on
set head on
set feedback on


set sqlprompt '&hostname &promptstr> '

--alter session set nls_numeric_characters = '.,';

define _editor=vim
