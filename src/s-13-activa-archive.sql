-- @Autores: Jorge Manzanares y Jesús Salazar 
-- @Fecha de creación: 31/05/2022
-- @Descripción: Creación de un spfile a partir de un pfile sin una instancia

connect sys /systemp as sysdba

-- Se respalda el archivo de parámetros textual antes de activar Archive
create pfile = '/home/oracle/pfilemasaproy-pre-archive.ora' from spfile;

/* 
Configuración de parámetros para del modo Archive
  - 5 procesos
  - La copia obligatoria se guarda en el "disco" d24 
  - Otra copia se pondrá en la FRA después de activarla 
  - Se requiere que se cree una copia por lo menos para considerar que el
    el proceso de archivado fue exitoso.
*/

alter system set log_archive_max_processes = 5 scope=spfile;
alter system set log_archive_dest_1='LOCATION=/unam-bda/d24/archivelogs MANDATORY'scope=spfile;
alter system set log_archive_format = 'arch_masaproy_%t_%s_%r.arc' scope=spfile;
alter system set log_archive_min_succeed_dest = 1 scope=spfile;

-- Se reinicia la base de datos en modo mount y se activa el modo archivelog
shutdown immediate
startup mount
alter database archivelog;

-- Se abre la base de datos y se comprueba que esté funcionando el modo archivelog
alter database open;
archive log list;

-- Se respalda el archivo de parámetros textual después de activar Archive
create pfile = '/home/oracle/pfilemasaproy-post-archive.ora' from spfile;