#!/bin/bash

BACKUP_DIR="/var/backups/db"
DATE=$(date +%Y%m%d)
BACKUP_FILE="$BACKUP_DIR/db_backup_$DATE.sql.gz"

mkdir -p "$BACKUP_DIR"

docker exec postgres pg_dump -U appuser appdb | gzip > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Backup successful : $BACKUP_FILE"
else
    echo "Backup failed"
    rm -f "$BACKUP_FILE"
fi
