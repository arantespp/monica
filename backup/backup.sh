#!/bin/bash

export $(xargs < ../.env)

rm backup.sql
docker exec mysql /usr/bin/mysqldump -u root --password=${MYSQL_ROOT_PASSWORD} --all-databases > backup.sql
aws s3 cp ./backup.sql s3://${AWS_BACKUP_BUCKET}/backup.sql
rm backup.sql