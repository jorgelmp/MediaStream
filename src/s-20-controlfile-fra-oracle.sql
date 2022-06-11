-- @Autores: Jorge Manzanares y Jesús Salazar 
-- @Fecha de creación: 09/06/2022
-- @Descripción: Copia de controlfile en la fra

-- ¡IMPORTANTE: EJECUTAR COMO USUARIO ORACLE DEL SISTEMA OPERATIVO!
connect sys/systemp as sysdba

-- Consultamos el valor de los control Files
show parameter control_files;

--Editar el parametro control file agregando el nombre del archivo de control creado en la FRA
alter system set 
  control_files = '/unam-bda/d11/app/oracle/oradata/MASAPROY/control01.ctl', 
  '/unam-bda/d12/app/oracle/oradata/MASAPROY/control02.ctl', '/unam-bda/d26/fra/control03.ctl'
  scope = spfile;

-- Se detiene la instancia y se inicia en modo nomount
shutdown immediate
startup nomount

-- Utilizando rman para mover el control file
!echo "restore controlfile from '/unam-bda/d13/app/oracle/oradata/MASAPROY/control03.ctl'; " | rman target /

--detener la instancia y levantarla en modo normal 
shutdown immediate
startup
