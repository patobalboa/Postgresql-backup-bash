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

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://www.codeplus.cl/wp-content/uploads/2022/06/codeplus_blanco_06.png">
  <source media="(prefers-color-scheme: light)" srcset="https://www.codeplus.cl/wp-content/uploads/2022/09/codeplus_06.png">
  <img alt="CodePlus.cl" src="https://www.codeplus.cl/wp-content/uploads/2022/06/codeplus_blanco_06.png">
</picture>


