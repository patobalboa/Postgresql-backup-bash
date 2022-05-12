# Postgresql-backup-bash

Script Bash para añadir al crontab y ejecutarlo diariamente para realizar un respaldo de tus bases de datos en PostgreSQL

Crontab Example:

```bash
# El respaldo se ejecutará a las 00:00 todos dias del año.
# y dejaremos un archivo de log que se actualizará todos dias para revisar en caso de llegarle un mail de falla de respaldo.

0 0 * * * sh /user/script-backup-ssh-remote.sh > /tmp/backup.log
```
