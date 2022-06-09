#!/bin/bash
#  @Autores: Jorge Manzanares y Jesús Salazar
#  @Fecha de creación: 26/05/2022
#  @Descripción: Creación de los loop devices que simulan los discos donde se
#                almacenan algunos archivos de la base de datos

# Se crea la carpeta de los loop devices
mkdir -p /unam-bda/disk-images

# Se crean los tres archivos que representan tres loop devices
cd /unam-bda/disk-images/
dd if=/dev/zero of=disk01.img bs=100M count=10
dd if=/dev/zero of=disk02.img bs=100M count=10
dd if=/dev/zero of=disk03.img bs=100M count=10

# Se comprueba la creación de los archivos
du -sh disk*.img

# Se asocian los loop devices a sus archivos
losetup -fP disk01.img
losetup -fP disk02.img
losetup -fP disk03.img

# Se confirma la creación de los tres loop devices
losetup -a

# Se construyen los sistemas de archivos (ext4) para los loop devices
mkfs.ext4 disk01.img
mkfs.ext4 disk02.img
mkfs.ext4 disk03.img

# Se crean los directorios donde los dispositivos serán montados
mkdir -p /unam-bda/d11
mkdir -p /unam-bda/d12
mkdir -p /unam-bda/d13

# Los loop devices se montaron en los directorios editando /etc/fstab

# Copiar, pegar y descomentar las siguientes líneas en al final de /etc/fstab

#   /unam-bda/disk-images/disk01.img         /unam-bda/d11   auto    loop    0       0
#   /unam-bda/disk-images/disk02.img         /unam-bda/d12   auto    loop    0       0
#   /unam-bda/disk-images/disk03.img         /unam-bda/d13   auto    loop    0       0