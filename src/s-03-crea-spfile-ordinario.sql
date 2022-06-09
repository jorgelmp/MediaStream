-- @Autores: Jorge Manzanares y Jesús Salazar 
-- @Fecha de creación: 31/05/2022
-- @Descripción: Creación de un spfile a partir de un pfile sin una instancia

prompt Conectando como sys as sysdba
connect sys/hola1234# as sysdba

prompt Creando el archivo spfile a partir del pfile
create spfile='$ORACLE_HOME/dbs/spfilemasaproy.ora' from pfile='$ORACLE_HOME/dbs/initmasaproy.ora';

prompt Comprobando la creación del spfile
!ls $ORACLE_HOME/dbs/spfilemasaproy.ora

