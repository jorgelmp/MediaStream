#!/bin/bash
#  @Autores: Jorge Manzanares y Jesús Salazar 
#  @Fecha de creación: 28/05/2022
#  @Descripción: Creación del archivo de parámetros textual

echo "1. Creando un archivo de parámetros básico"
export ORACLE_SID=masaproy
pfile=$ORACLE_HOME/dbs/init${ORACLE_SID}.ora

if [ -f "${pfile}" ]; then
  read -p "El archivo ${pfile} ya existe, [enter] para sobrescribir"
fi;
echo \
"db_name='${ORACLE_SID}'
memory_target=1G
control_files=(/unam-bda/d11/app/oracle/oradata/${ORACLE_SID^^}/control01.ctl,
               /unam-bda/d12/app/oracle/oradata/${ORACLE_SID^^}/control02.ctl,
               /unam-bda/d13/app/oracle/oradata/${ORACLE_SID^^}/control03.ctl)
" >$pfile
echo "Listo"
echo "Comprobando la existencia y contenido del PFILE"
echo ""
cat ${pfile}