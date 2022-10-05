# Postgresql-backup-bash

Script to backup Postgresql database and send it to remote server with rsync and sendmail.

## Requirements

* Postgresql
* Rsync
* Sendmail
* ssh-keygen and ssh-copy-id
* SSH access to remote server


## Installation

### 1. Create a backup user

Create a user with the name of your choice. This user will be used to backup the database.

```bash
sudo -u postgres createuser -P -s -e backup
```

### 2. Create a backup directory

Create a directory where the backup will be stored.

```bash
sudo mkdir /var/backups/postgresql
sudo chown postgres:postgres /var/backups/postgresql
```

### 3. Clone the repository and make the script executable

```bash
git clone https://github.com/patobalboa/postgresql-backup-bash.git
cd postgresql-backup-bash
chmod +x postgresql-backup.sh
```

### 4. Configure the script

Edit the file `script-backup-ssh-remote.sh` and change the variables to your needs.

```bash
## Variables Database
# Database name
DATABASE_NAME="database_name"
# Database user
DATABASE_USER="backup"
# Database password
DATABASE_PASSWORD="password"
# Database host
DATABASE_HOST="localhost"
# Database port
DATABASE_PORT="5432"
# Database backup directory
DATABASE_BACKUP_PATH="/var/backups/postgresql"
# Database backup filename
DATABASE_BACKUP_FILENAME="database_name_"+"_"+"$(date +%Y-%m-%d_%H-%M-%S)"

## Variables Rsync
# Remote server
SSH_HOST="my_remote_server"
# Remote server backup directory
SSH_BACKUP_DIR="/var/backups/postgresql"
# Remote server backup user
SSH_USER="backup"
# Remote server ssh port
SSH_PORT="22"

## Variables Sendmail
# Sendmail from
SENDMAIL_FROM = "backups@domain.com"
SENDMAIL_TO = "mail@domain.com"
SENDMAIL_SUBJECT = "Backup from remote server"
SENDMAIL_BODY_ERROR = "Error while executing backup script"
SENDMAIL_BODY_SUCCESS = "Backup from remote server successful"
```

### 5. Configure the crontab

```bash 
$ crontab -e

#Explain: Cron job to run script every day at 00:00

0 0 * * * /path/to/postgresql-backup-bash.sh
```

### 6. Configure the SSH access

Generate a SSH key pair. (If you already have one, skip this step)

```bash
ssh-keygen -t rsa
```

Copy the public key to the remote server.

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub backup@my_remote_server
```

### 7. Test the script

```bash
./script-backup-ssh-remote.sh
```

## License
GNU General Public License v3.0

## Powered by

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://www.codeplus.cl/wp-content/uploads/2022/06/codeplus_blanco_06.png">
  <source media="(prefers-color-scheme: light)" srcset="https://www.codeplus.cl/wp-content/uploads/2022/09/codeplus_06.png">
  <img alt="CodePlus.cl" src="https://www.codeplus.cl/wp-content/uploads/2022/06/codeplus_blanco_06.png">
</picture>


