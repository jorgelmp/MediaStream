-- @Autores: Jorge Manzanares y Jesús Salazar
-- @Fecha de creación: 04/06/2022
-- @Descripción: Modos de conexión

-- Agrear las siguientes tres entradas en $ORACLE_HOME/network/admin/tnsnames.ora
--------------------------------------------------------------------------------
--  MASAPROY_POOLED =
--    (DESCRIPTION =
--      (ADDRESS_LIST =
--        (ADDRESS = (PROTOCOL = TCP)(HOST = pc-jmp.fi.unam)(PORT = 1521))
--      )
--    (CONNECT_DATA =
--      (SERVICE_NAME = masaproy.fi.unam)
--      (SERVER = POOLED)
--    )
--  )
--
--  MASAPROY =
--    (DESCRIPTION =
--      (ADDRESS_LIST =
--        (ADDRESS = (PROTOCOL = TCP)(HOST = pc-jmp.fi.unam)(PORT = 1521))
--      )
--      (CONNECT_DATA =
--        (SERVICE_NAME = masaproy.fi.unam)
--        (SERVER = DEDICATED)
--      )
--   )
-- 
--  MASAPROY_SHARED =
--    (DESCRIPTION =
--      (ADDRESS_LIST =
--        (ADDRESS = (PROTOCOL = TCP)(HOST = pc-jmp.fi.unam)(PORT = 1521))
--      )
--      (CONNECT_DATA =
--        (SERVICE_NAME = masaproy.fi.unam)
--        (SERVER = SHARED)
--      )
--    )
--------------------------------------------------------------------------------
connect sys /systemp as sysdba;

alter system set db_domain='fi.unam' scope=spfile;

shutdown immediate

startup

prompt Configurando una conexión en modo compartido y pooled 

alter system set dispatchers = '(dispatchers=4) (protocol=TCP)';
alter system set shared_servers = 8;

exec dbms_connection_pool.start_pool();

exec dbms_connection_pool.alter_param('','MAXSIZE',50);
exec dbms_connection_pool.alter_param('','MINSIZE',35);

exec dbms_connection_pool.alter_param('','INACTIVITY_TIMEOUT', 1800);
exec dbms_connection_pool.alter_param('','MAX_THINK_TIME',1800);

alter system register;
