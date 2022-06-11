#!/bin/bash
#  @Autores: Jorge Manzanares y Jesús Salazar
#  @Fecha de creación: 08/06/2022
#  @Descripción: Creación de los directorios para backups

dirBackup="/unam-bda/d25/backups"
mkdir -p ${dirBackup}

chown oracle:oinstall ${dirBackup}
chmod 750 ${dirBackup}