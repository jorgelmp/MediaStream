-- @Autores: Jorge Manzanares y Jesús Salazar
-- @Fecha de creación: 01/07/2022
-- @Descripción: Creación de diccionario de datos para la base de datos 

connect sys/systemp as sysdba
@?/rdbms/admin/catalog.sql
@?/rdbms/admin/catproc.sql
@?/rdbms/admin/utlrp.sql

connect system/systemp
@?/sqlplus/admin/pupbld.sql
