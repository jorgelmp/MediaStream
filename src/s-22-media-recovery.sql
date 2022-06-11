-- @Autores: Jorge Manzanares y Jesús Salazar 
-- @Fecha de creación: 10/06/2022
-- @Descripción: Proceso de media recovery

--EJECUTAR como USARIO ORACLE

!mv /unam-bda/d14/media_content.dbf /unam-bda/d14/media_content_failure.dbf

shutdown immediate

startup mount

/*
En una terminal con usuario oracle
$ export ORACLE_SID=masaproy
$ rman target /

Desde RMAN
RMAN> list failure
RMAN> advise failure
RMAN> restore datafile 5;
RMAN> recover datafile 5;
RMAN> sql 'alter database datafile 5 online';
*/



