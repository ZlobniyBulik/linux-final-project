#!/bin/bash
# Потабличный бэкап БД wordpress со slave сервера
# Сохраняем позицию бинлога

BACKUP_DIR=/backup/mysql
DATE=$(date +%F_%H-%M)
DB=wordpress

mkdir -p $BACKUP_DIR/$DATE

# Сохраняем позицию бинлога
mysql -u root -pYOURPASS -e "SHOW MASTER STATUS\G" > $BACKUP_DIR/$DATE/binlog_pos.txt

# Потабличный дамп
for table in $(mysql -u root -p123456Qq -N -e "SHOW TABLES FROM $DB"); do
  mysqldump -u root -pYOURPASS $DB $table > $BACKUP_DIR/$DATE/$table.sql
done
