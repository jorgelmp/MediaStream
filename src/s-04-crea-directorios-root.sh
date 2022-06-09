#!/bin/bash
# @Autores: Jorge Manzanares y Jesús Salazar
# @Fecha de creación: 31/05/2022
# @Descripción: Creación de los directorios para la base de datos 

export ORACLE_SID=masaproy

# Se crea el directorio para los datafiles compartidos de la base de datos nueva
dirDf="${ORACLE_BASE}/oradata/${ORACLE_SID^^}"
mkdir -p  ${dirDf}

# Se crean los directorios para los datafiles de cada tablespace (cada disco)
mkdir -p /unam-bda/d14/app/oracle/oradata/${ORACLE_SID^^}
mkdir -p /unam-bda/d15/app/oracle/oradata/${ORACLE_SID^^}
mkdir -p /unam-bda/d16/app/oracle/oradata/${ORACLE_SID^^}
mkdir -p /unam-bda/d17/app/oracle/oradata/${ORACLE_SID^^}
mkdir -p /unam-bda/d18/app/oracle/oradata/${ORACLE_SID^^}
mkdir -p /unam-bda/d19/app/oracle/oradata/${ORACLE_SID^^}
mkdir -p /unam-bda/d20/app/oracle/oradata/${ORACLE_SID^^}
mkdir -p /unam-bda/d21/app/oracle/oradata/${ORACLE_SID^^}
mkdir -p /unam-bda/d22/app/oracle/oradata/${ORACLE_SID^^}
mkdir -p /unam-bda/d23/app/oracle/oradata/${ORACLE_SID^^}
mkdir -p /unam-bda/d24/app/oracle/oradata/${ORACLE_SID^^}
mkdir -p /unam-bda/d25/app/oracle/oradata/${ORACLE_SID^^}

# Se asignan los permisos adecuados al directorio de los datafiles
chown oracle:oinstall ${dirDf}
chmod 750 ${dirDf}

chown oracle:oinstall /unam-bda/d1*/app/oracle/oradata/${ORACLE_SID^^}
chown oracle:oinstall /unam-bda/d2*/app/oracle/oradata/${ORACLE_SID^^}
chmod 750 /unam-bda/d1*/app/oracle/oradata/${ORACLE_SID^^}
chmod 750 /unam-bda/d2*/app/oracle/oradata/${ORACLE_SID^^}

# Se crean los directorios para los Redo Logs y los control files
mkdir -p /unam-bda/d11/app/oracle/oradata/${ORACLE_SID^^} 
chown -R oracle:oinstall /unam-bda/d11/app

mkdir -p /unam-bda/d12/app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall /unam-bda/d12/app

mkdir -p /unam-bda/d13/app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall /unam-bda/d13/app

echo "Mostrando directorio de data files compartidos"
ls -l /u01/app/oracle/oradata

echo "Mostrado directorio para control files y Redo Logs y data files"
ls -l /unam-bda/d1*/app/oracle/oradata
ls -l /unam-bda/d2*/app/oracle/oradata
