#!/bin/bash
#  @Autores: Jorge Manzanares y Jesús Salazar
#  @Fecha de creación: 05/06/2022
#  @Descripción: Creación de los directorios para archives redo logs

dirArchive="/unam-bda/d24/archivelogs"
mkdir -p ${dirArchive}

chown oracle:oinstall ${dirArchive}
chmod 750 ${dirArchive}

