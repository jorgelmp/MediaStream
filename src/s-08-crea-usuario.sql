-- @Autores: Jorge Manzanares y Jesús Salazar
-- @Fecha de creación: 01/07/2022
-- @Descripción: Creación de los usuarios de la base de datos

connect sys/systemp as sysdba

whenever sqlerror exit rollback

declare
  v_count number;
  v_rolename varchar2(20) := 'ADMIN';
begin
  select count(*) into v_count from dba_roles where role=v_rolename;
  if v_count > 0 then
    execute immediate 'drop role '||v_rolename;
  end if;
end;
/
create role admin;
grant create session, create table, create sequence, create synonym,
  create public synonym, create view, create procedure, create trigger
  to admin;

declare
  v_count number;
  v_username varchar2(20) := 'ADMIN_MULTIMEDIA';
begin
  select count(*) into v_count from all_users where username=v_username;
  if v_count > 0 then
    execute immediate 'drop user '||v_username|| ' cascade';
  end if;
end;
/
create user admin_multimedia identified by multimedia 
  default tablespace media_datos_tbs
  temporary tablespace media_temporales_tbs
  quota unlimited on media_contenidos_tbs
  quota unlimited on media_historicos_tbs
  quota unlimited on media_indices_tbs
  --quota unlimited on media_undo_tbs;

declare
  v_count number;
  v_username varchar2(20) := 'ADMIN_USUARIOS';
begin
  select count(*) into v_count from all_users where username=v_username;
  if v_count > 0 then
    execute immediate 'drop user '||v_username|| ' cascade';
  end if;
end;
/
create user admin_usuarios identified by usuarios
  default tablespace usuarios_datos_tbs
  temporary tablespace usuarios_temporales_tbs
  quota unlimited on usuarios_historicos_tbs
  quota unlimited on usuarios_indices_tbs
  --quota unlimited on usuarios_undo_tbs;

grant admin to admin_usuarios, admin_multimedia;

disconnect;