#!/bin/bash
# Ruta en la que guardar los backups

backup_dir="/tmp/respaldos"
fecha_dir=$(date +%b-%Y/)
fecha=$(date +%d-%m-%Y)
archivo1="database1-"
extension=".backup"
archivo2="database2-"
carpeta_date=$backup_dir$fecha_dir


if [ ! -d "$carpeta_date" ];
then
    mkdir -p "$carpeta_date"
fi

archivo_db1=$carpeta_date$archivo2$fecha$extension
archivo_db2=$carpeta_date$archivo1$fecha$extension





export PGPASSWORD="YOUR_PASSWORD_DATABASE"



pg_dump -h localhost -U postgres -F c -b -v -f $archivo_db1 database1


#Preconfigura tu sendmail para enviar una alarma a traves de un correo.

if [ -f "$archivo_db1" ]; then
    echo "Subject: Exito: Respaldo Database1 \n\n Respaldo realizado correctamente." | /usr/sbin/sendmail -vf alertas@domain.cl tumail@domain.cl
else
    echo 'Subject: Fallido: Respaldo Database1 \n\n No se hizo el respaldo, Revisar Urgente.' | /usr/sbin/sendmail -vf alertas@domain.cl tumail@domain.cl
fi

pg_dump -h localhost -U postgres -F c -b -v -f $archivo_db2 database2

if [ -f "$archivo_db2" ]; then
    echo "Subject: Exito: Respaldo Database2 \n\n Respaldo realizado correctamente." | /usr/sbin/sendmail -vf alertas@domain.cl tumail@domain.cl
else
    echo 'Subject: Fallido: Respaldo Database2 \n\n No se hizo el respaldo, Revisar Urgente.' | /usr/sbin/sendmail -vf alertas@domain.cl tumail@domain.cl
fi