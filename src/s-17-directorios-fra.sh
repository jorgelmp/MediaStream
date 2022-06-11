# @Autores: Jorge Manzanares y Jesús Salazar 
# @Fecha de creación: 31/05/2022
#  @Descripción: Creación de los directorios para backups

dirRedo="/unam-bda/d27/redo"
dirFra="/unam-bda/d26/fra"
mkdir -p ${dirFra}
mkdir -p ${dirRedo}

chown oracle:oinstall ${dirFra}
chmod 750 ${dirFra}

chown oracle:oinstall ${dirRedo}
chmod 750 ${dirRedo}