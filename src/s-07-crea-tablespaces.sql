-- @Autores: Jorge Manzanares y Jesús Salazar
-- @Fecha de creación: 01/06/2022
-- @Descripción: Creación de los tablespaces de la base de datos

connect sys/systemp as sysdba

set serveroutput on;
whenever sqlerror exit rollback

declare
  cursor cur_constraits is 
    select OWNER, CONSTRAINT_NAME, TABLE_NAME, CONSTRAINT_TYPE from DBA_CONSTRAINTS 
      where owner like 'ADMIN_%' and CONSTRAINT_TYPE <> 'C';

  cursor cur_ts is 
    select tablespace_name from dba_tablespaces where tablespace_name like '%_TBS'
      order by 1 desc;

begin
  for c in cur_constraits loop
    DBMS_OUTPUT.PUT_LINE('Eliminando el constrait => ' || c.constraint_name);
    execute immediate 'alter table ' || c.owner ||'.'||c.table_name 
      || ' drop constraint ' || c.constraint_name;
  end loop;

  for t in cur_ts loop
    DBMS_OUTPUT.PUT_LINE('Eliminando el tablespace => ' || t.tablespace_name);
    execute immediate 'drop tablespace ' || t.tablespace_name 
      || ' including contents and datafiles';
  end loop;
exception
  when others then
    dbms_output.put_line('ERROR, excepción inesperada => ' || TO_CHAR(sqlcode));
    dbms_output.put_line('ERROR => ' || SQLERRM);
end;
/

create bigfile tablespace media_contenidos_tbs
  datafile '/unam-bda/d14/app/oracle/oradata/MASAPROY/media_content.dbf' 
  size 3G
  extent management local autoallocate
  segment space management auto;

create tablespace media_datos_tbs
  datafile '/unam-bda/d15/app/oracle/oradata/MASAPROY/media_datos01.dbf' 
  size 300M
  autoextend on next 100M maxsize 500M
  extent management local autoallocate
  segment space management auto;

create bigfile tablespace media_historicos_tbs
  datafile '/unam-bda/d16/app/oracle/oradata/MASAPROY/media_historicos.dbf'
  size 3G
  extent management local autoallocate
  segment space management auto;

create tablespace media_indices_tbs
  datafile '/unam-bda/d17/app/oracle/oradata/MASAPROY/media_indices01.dbf' 
  size 300M
  autoextend on next 100M maxsize 500M
  extent management local autoallocate
  segment space management auto;

create temporary tablespace media_temporales_tbs
  tempfile '/unam-bda/d18/app/oracle/oradata/MASAPROY/media_temporales01.dbf' 
  size 20M 
  autoextend on next 100M maxsize 500M;

--create undo tablespace media_undo_tbs
--  datafile '/unam-bda/d19/app/oracle/oradata/MASAPROY/media_undo01.dbf' 
--  size 300M
--  autoextend on next 100M maxsize 500M
--  extent management local autoallocate; 

!mkdir -p ${ORACLE_BASE}/admin/${ORACLE_SID}/wallet
alter system set encryption key identified by "systemp"; 
alter system set encryption wallet open identified by "systemp";

create tablespace usuarios_bancarios_tbs
  datafile '/unam-bda/d19/app/oracle/oradata/MASAPROY/usuarios_bancarios01.dbf'
  size 300M
  autoextend on next 100M maxsize 500M
  encryption using 'aes128' encrypt
  extent management local autoallocate
  segment space management auto;

create tablespace usuarios_datos_tbs
  datafile '/unam-bda/d20/app/oracle/oradata/MASAPROY/usuarios_datos01.dbf'
  size 300M
  autoextend on next 100M maxsize 500M
  extent management local autoallocate
  segment space management auto;

create bigfile tablespace usuarios_historicos_tbs
  datafile '/unam-bda/d21/app/oracle/oradata/MASAPROY/usuarios_historicos.dbf'
  size 3G
  extent management local autoallocate
  segment space management auto;

create tablespace usuarios_indices_tbs
  datafile '/unam-bda/d22/app/oracle/oradata/MASAPROY/usuarios_indices01.dbf' 
  size 300M
  autoextend on next 100M maxsize 500M
  extent management local autoallocate
  segment space management auto;

create temporary tablespace usuarios_temporales_tbs
  tempfile '/unam-bda/d23/app/oracle/oradata/MASAPROY/usuarios_temporales01.dbf' 
  size 20M 
  autoextend on next 100M maxsize 500M;

--create undo tablespace usuarios_undo_tbs
--  datafile '/unam-bda/d25/app/oracle/oradata/MASAPROY/usuarios_undo01.dbf' 
--  size 300M
--  autoextend on next 100M maxsize 500M
--  extent management local autoallocate
--  retention guarantee;

disconnect;