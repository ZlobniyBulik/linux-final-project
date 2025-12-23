#!/bin/bash

# Параметры
USER="root"
PASSWORD="123456Qq"      # поменяй на свой пароль
DB="wordpress"
BACKUP_DIR="/backup/mysql_slave"
DATE=$(date +%F_%H-%M-%S)

# Создаем директорию для бэкапа
mkdir -p "$BACKUP_DIR/$DATE"

# Получаем текущую позицию бинарного лога Master
MASTER_LOG=$(mysql -u $USER -p$PASSWORD -e "SHOW SLAVE STATUS\G" | grep 'Master_Log_File:' | awk '{print $2}')
MASTER_POS=$(mysql -u $USER -p$PASSWORD -e "SHOW SLAVE STATUS\G" | grep 'Exec_Master_Log_Pos:' | awk '{print $2}')

echo "Backing up Slave DB: $DB"
echo "Master Log: $MASTER_LOG, Position: $MASTER_POS"

# Сохраняем позицию бинлога в файл
echo "Master_Log_File: $MASTER_LOG" > "$BACKUP_DIR/$DATE/backup_position.txt"
echo "Exec_Master_Log_Pos: $MASTER_POS" >> "$BACKUP_DIR/$DATE/backup_position.txt"

# Получаем список таблиц
TABLES=$(mysql -u $USER -p$PASSWORD -e "SHOW TABLES FROM $DB;" | tail -n +2)

# Делаем дамп каждой таблицы отдельно
for TABLE in $TABLES; do
    echo "Backing up table: $TABLE"
    mysqldump -u $USER -p$PASSWORD $DB $TABLE > "$BACKUP_DIR/$DATE/${TABLE}.sql"
done

echo "Backup completed: $BACKUP_DIR/$DATE"
