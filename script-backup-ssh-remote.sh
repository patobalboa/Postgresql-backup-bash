#!/bin/bash
# https://github.com/patobalboa

# Backup the postgresql script for remote servers with rsync and mail notification via sendmail.
#
# Requirements:
# - rsync
# - sendmail
# - ssh
# - crontab
#
# Usage:
# ./script-backup-ssh-remote.sh
#
# Configuration
#
# Set the following variables to your needs:
# - SENDMAIL
SENDMAIL_FROM = "backups@domain.com"
SENDMAIL_TO = "mail@domain.com"
SENDMAIL_SUBJECT = "Backup from remote server"
SENDMAIL_BODY_ERROR = "Error while executing backup script"
SENDMAIL_BODY_SUCCESS = "Backup from remote server successful"


# - POSTGRESQL
export PGPASSWORD="YOUR_PASSWORD_DATABASE"
DATABASE_NAME="DATABASE_NAME"
DATABASE_USERNAME="DATABASE_USERNAME"
DATABASE_HOST="DATABASE_HOST"
DATABASE_PORT="DATABASE_PORT"
DATABASE_BACKUP_PATH="/backup/path"+"-"+$(date +%b-%Y)
DATABASE_BACKUP_NAME="DATABASE_BACKUP_NAME"+"_"+"$(date +%Y-%m-%d_%H-%M-%S)"

# - SSH
SSH_USERNAME="SSH_USERNAME"
SSH_HOST="SSH_HOST"
SSH_PORT="SSH_PORT"
SSH_BACKUP_PATH="/backup/path"

# - CRONTAB
CRONTAB_COMMAND="0 0 * * * /path/to/script-backup-ssh-remote.sh"

# - RSYNC
RSYNC_OPTIONS="-avz --delete"

# - MAIL
MAIL_OPTIONS="-vf $SENDMAIL_FROM $SENDMAIL_TO"

# - LOG
LOG_FILE="/path/to/log/file"

# Functions

function send_mail {
    if [ $1 -eq 0 ]; then
        echo "$SENDMAIL_SUBJECT \n\n $SENDMAIL_BODY_SUCCESS" | /usr/sbin/sendmail $MAIL_OPTIONS
    else
        echo "$SENDMAIL_SUBJECT \n\n $SENDMAIL_BODY_ERROR" | /usr/sbin/sendmail $MAIL_OPTIONS
    fi
}

function log {
    echo "$(date +"%Y-%m-%d %H:%M:%S") $1" >> $LOG_FILE
}

function backup_database {
    log "Backing up database $DATABASE_NAME"
    pg_dump -U $DATABASE_USERNAME -h $DATABASE_HOST -p $DATABASE_PORT $DATABASE_NAME > $DATABASE_BACKUP_PATH/$DATABASE_BACKUP_NAME.sql
    if [ $? -eq 0 ]; then
        log "Database backup successful"
    else
        log "Database backup failed"
        exit 1
    fi
}

function backup_ssh {
    log "Backing up ssh"
    rsync $RSYNC_OPTIONS $DATABASE_BACKUP_PATH $SSH_USERNAME@$SSH_HOST:$SSH_BACKUP_PATH
    if [ $? -eq 0 ]; then
        log "SSH backup successful"
    else
        log "SSH backup failed"
    fi
}

function backup_crontab {
    log "Backing up crontab"
    crontab -l > $DATABASE_BACKUP_PATH/$DATABASE_BACKUP_NAME.crontab
    if [ $? -eq 0 ]; then
        log "Crontab backup successful"
    else
        log "Crontab backup failed"
    fi
}

function backup_all {
    backup_database
    backup_ssh
    backup_crontab
}

# Main
# Check if the script is executed as root
if [ "$(id -u)" != "0" ]; then
    log "This script must be run as root"
    send_mail 1
    exit 1
fi

# Check if the directories exist
if [ ! -d $DATABASE_BACKUP_PATH ]; then
    log "Creating directory $DATABASE_BACKUP_PATH"
    mkdir -p $DATABASE_BACKUP_PATH
fi
if [ ! -d $DATABASE_BACKUP_PATH ]; then
    log "Directory $DATABASE_BACKUP_PATH does not exist"
    send_mail 1
    exit 1
fi

log "Starting backup"
backup_all
if [ $? -eq 0 ]; then
    log "Backup successful"
else
    log "Backup failed"
fi
log "Ending backup"
send_mail $?
log "Backup finished"
exit 0