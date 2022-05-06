#!/bin/bash
# Ruta en la que guardar los backups

backup_dir="/datos/postgresql/respaldos/"
fecha_dir=$(date +%b-%Y/)
fecha=$(date +%d-%m-%Y)
archivo="localizagps-"
extension=".backup"
agrosuper="agrosuper-"
carpeta_date=$backup_dir$fecha_dir


if [ ! -d "$carpeta_date" ];
then
    mkdir -p "$carpeta_date"
fi

archivo_localiza=$carpeta_date$archivo$fecha$extension
archivo_agrosuper=$carpeta_date$agrosuper$fecha$extension




export PGPASSWORD="8KaL8bxJkpGg"



pg_dump -h localhost -U postgres -F c -b -v -f $archivo_agrosuper agrosuper

if [ -f "$archivo_agrosuper" ]; then
    echo "Subject: Exito: Respaldo Agrosuper \n\n Respaldo realizado correctamente." | /usr/sbin/sendmail -vf alertas@ftrack.cl pbalboa@ftrack.cl
else
    echo 'Subject: Fallido: Respaldo Agrosuper \n\n No se hizo el respaldo, Revisar Urgente.' | /usr/sbin/sendmail -vf alertas@ftrack.cl pbalboa@ftrack.cl
fi

pg_dump -h localhost -U postgres -F c -b -v -f $archivo_localiza localizagps

if [ -f "$archivo_localiza" ]; then
    echo "Subject: Exito: Respaldo Localiza \n\n Respaldo realizado correctamente." | /usr/sbin/sendmail -vf alertas@ftrack.cl pbalboa@ftrack.cl
else
    echo 'Subject: Fallido: Respaldo Localiza \n\n No se hizo el respaldo, Revisar Urgente.' | /usr/sbin/sendmail -vf alertas@ftrack.cl pbalboa@ftrack.cl
fi