#!/bin/bash
#  @Autores: Jorge Manzanares y Jesús Salazar
#  @Fecha de creación: 26/05/2022
#  @Descripción: Creación de archivo de contraseñas para la base de datos

# Se genera el archivo de contraseñas con orapwd
echo "Creando nuevo archivo de contraseñas"
export ORALCE_SID=masaproy
orapwd FILE='${ORACLE_HOME}/dbs/orapwmasaproy' FORCE=Y FORMAT=12.2 \
  sys=password\
  sysbackup=password

# Se valida la creación del archivo de contraseñas
echo "Validando creación del archvio de contraseñas"
ls -l $ORACLE_HOME/dbs/orapwmasaproy
