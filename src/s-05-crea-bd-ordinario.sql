-- @Autor: Jorge Manzanares y Jesús Salazar 
-- @Fecha de creación: 01/07/2022
-- @Descripción: Creación de la base de datos del curso

connect sys/hola1234# as sysdba

startup nomount

whenever sqlerror exit rollback;

create database masaproy
  user sys identified by systemp 
  user system identified by systemp  
  logfile group 1 ( 
    '/unam-bda/d11/app/oracle/oradata/MASAPROY/redo01a.log', 
    '/unam-bda/d12/app/oracle/oradata/MASAPROY/redo01b.log', 
    '/unam-bda/d13/app/oracle/oradata/MASAPROY/redo01c.log') size 50m blocksize 512, 
  group 2 ( 
    '/unam-bda/d11/app/oracle/oradata/MASAPROY/redo02a.log', 
    '/unam-bda/d12/app/oracle/oradata/MASAPROY/redo02b.log', 
    '/unam-bda/d13/app/oracle/oradata/MASAPROY/redo02c.log') size 50m blocksize 512, 
  group 3 ( 
    '/unam-bda/d11/app/oracle/oradata/MASAPROY/redo03a.log', 
    '/unam-bda/d12/app/oracle/oradata/MASAPROY/redo03b.log', 
    '/unam-bda/d13/app/oracle/oradata/MASAPROY/redo03c.log') size 50m blocksize 512 
   maxloghistory 1 
   maxlogfiles 16 
   maxlogmembers 3 
   maxdatafiles 1024 
   character set AL32UTF8 
   national character set AL16UTF16 
   extent management local 
   datafile '/u01/app/oracle/oradata/MASAPROY/system01.dbf' 
     size 1G reuse autoextend on next 10240k maxsize unlimited 
   sysaux datafile '/u01/app/oracle/oradata/MASAPROY/sysaux01.dbf' 
     size 1G reuse autoextend on next 10240k maxsize unlimited 
   default tablespace users 
      datafile '/u01/app/oracle/oradata/MASAPROY/users01.dbf' 
      size 500m reuse autoextend on maxsize unlimited 
   default temporary tablespace tempts1 
      tempfile '/u01/app/oracle/oradata/MASAPROY/temp01.dbf'
      size 20m reuse autoextend on next 640k maxsize unlimited 
   undo tablespace undotbs1 
      datafile '/u01/app/oracle/oradata/MASAPROY/undotbs01.dbf' 
      size 200m reuse autoextend on next 5120k maxsize unlimited;


alter user sys identified by systemp;
alter user system identified by systemp;
alter user sysbackup identified by systemb;
