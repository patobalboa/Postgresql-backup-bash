#!/bin/bash


# Set de la ruta en la que guardar los backups
backup_dir="/tmp/respaldos"
# Set fecha para la creación del directorio con el Mes y el Año
fecha_dir=$(date +%b-%Y/)
# Set fecha de la creación del archivo .backup
fecha=$(date +%d-%m-%Y)
extension=".backup"
#Set del inicio del nombre del archivo de los backups
archivo1="database1-"
archivo2="database2-"

# Creación de la carpeta donde se guardarán los respaldos segun el Mes
carpeta_date=$backup_dir$fecha_dir

if [ ! -d "$carpeta_date" ];
then
    mkdir -p "$carpeta_date"
fi

#Set del path completo de donde y como se definirá el respaldo
archivo_db1=$carpeta_date$archivo1$fecha$extension
archivo_db2=$carpeta_date$archivo2$fecha$extension

# Exportamos la password de la base de datos al enviroment del crontab
export PGPASSWORD="YOUR_PASSWORD_DATABASE"

# Añadimos los el comando para la creación de las base de datos.
pg_dump -h localhost -U postgres -F c -b -v -f $archivo_db1 database1
pg_dump -h localhost -U postgres -F c -b -v -f $archivo_db2 database2


# Preconfigura tu sendmail para enviar una alerta a traves de un correo.
# Preguntamos si se creó correctamente el archivo de respaldo y enviaremos un mail si se hizo correctamente o no.

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