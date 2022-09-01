# Postgresql-backup-bash

Script to backup Postgresql database and send it to remote server with rsync and sendmail.

## Requirements

* Postgresql
* Rsync
* Sendmail

## Installation

```bash
$ git clone https://github.com/patobalboa/Postgresql-backup-bash.git
```

## Usage

```bash
$ ./postgresql-backup-bash.sh
```

## Crontab Example

```bash 
$ crontab -e

#Explain: Cron job to run script every day at 00:00

0 0 * * * /path/to/postgresql-backup-bash.sh
```

## License
GNU General Public License v3.0

## Powered by

![Logo](https://www.codeplus.cl/wp-content/uploads/2022/06/codeplus_blanco_06.png)


