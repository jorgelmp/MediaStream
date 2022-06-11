-- @Autores: Jorge Manzanares y Jesús Salazar 
-- @Fecha de creación: 09/06/2022
-- @Descripción: Creación de datos redo para módulo usuarios

whenever sqlerror exit rollback;

connect sys/systemp as sysdba;

alter system set db_recovery_file_dest_size = 1600M;
alter system set db_recovery_file_dest = '/unam-bda/d26/fra/';
alter system set db_flashback_retention_target = 1440;

alter system set log_archive_dest_2='LOCATION=USE_DB_RECOVERY_FILE_DEST';

alter system set db_create_file_dest = '/unam-bda/d11/app/oracle/oradata/MASAPROY/';

-- Para sustiruir los online redo logs creados anteriormente
--    - Hacer log switches (alter system switch logfile;) hasta que los tres
--      grupos estén inactivos
--    - Ejecutar alter system drop logfile group 1 (2 y 3)
--    - Crear tres grupos nuevos sin especificar ruta

alter database add logfile group 4 size 50m;
alter database add logfile group 5 size 50m;
alter database add logfile group 6 size 50m;
