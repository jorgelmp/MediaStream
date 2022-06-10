-- @Autores: Jorge Manzanares y Jesús Salazar
-- @Fecha de creación: 05/06/2022
-- @Descripción: Creación de los objetos del módulo USUARIOS de Media Stream

whenever  sqlerror exit rollback

connect sys/systemp as sysdba

declare
  cursor cur_tables is 
    select TABLE_NAME,OWNER from ALL_TABLES where OWNER in('ADMIN_MULTIMEDIA','ADMIN_USUARIOS');
begin
  for t in cur_tables loop
    DBMS_OUTPUT.PUT_LINE('Desactivando logging para la tabla => ' || t.table_name);
    execute immediate 'alter table '||t.owner|| '.' || t.table_name || ' nologging';
  end loop;
exception
  when others then
    dbms_output.put_line('ERROR, excepción inesperada => ' || TO_CHAR(sqlcode));
    dbms_output.put_line('ERROR => ' || SQLERRM);
end;
/
/*
connect ADMIN_MULTIMEDIA/multimedia
@@carga_inicial/s-11-1-carga-datos.sql
@@carga_inicial/s-11-2-carga-datos.sql
@@carga_inicial/s-11-3-carga-datos.sql
@@carga_inicial/s-11-4-carga-datos.sql
@@carga_inicial/s-11-5-carga-datos.sql
@@carga_inicial/s-11-6-carga-datos.sql
@@carga_inicial/s-11-7-carga-datos.sql
@@carga_inicial/s-11-8-carga-datos.sql
@@carga_inicial/s-11-9-carga-datos.sql
@@carga_inicial/s-11-10-carga-datos.sql
@@carga_inicial/s-11-11-carga-datos.sql
@@carga_inicial/s-11-12-carga-datos.sql
@@carga_inicial/s-11-13-carga-datos.sql
@@carga_inicial/s-11-14-carga-datos.sql
@@carga_inicial/s-11-15-carga-datos.sql
*/
connect ADMIN_USUARIOS/usuarios
@@carga_inicial/s-11-16-carga-datos.sql
@@carga_inicial/s-11-17-carga-datos.sql
@@carga_inicial/s-11-18-carga-datos.sql
@@carga_inicial/s-11-19-carga-datos.sql
@@carga_inicial/s-11-20-carga-datos.sql
@@carga_inicial/s-11-21-carga-datos.sql
@@carga_inicial/s-11-22-carga-datos.sql
@@carga_inicial/s-11-23-carga-datos.sql
@@carga_inicial/s-11-24-carga-datos.sql
@@carga_inicial/s-11-25-carga-datos.sql
@@carga_inicial/s-11-26-carga-datos.sql
@@carga_inicial/s-11-27-carga-datos.sql
@@carga_inicial/s-11-28-carga-datos.sql

commit;

connect sys/systemp as sysdba

declare
  cursor cur_tables is 
    select TABLE_NAME,OWNER from ALL_TABLES where OWNER in('ADMIN_MULTIMEDIA','ADMIN_USUARIOS');
begin
  for t in cur_tables loop
    DBMS_OUTPUT.PUT_LINE('Activando logging para la tabla => ' || t.table_name);
    execute immediate 'alter table '||t.owner|| '.' || t.table_name || ' logging';
  end loop;
exception
  when others then
    dbms_output.put_line('ERROR, excepción inesperada => ' || TO_CHAR(sqlcode));
    dbms_output.put_line('ERROR => ' || SQLERRM);
end;
/

disconnect