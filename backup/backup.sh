export $(xargs < .env)

docker exec mysql /usr/bin/mysqldump -u root --password=${MYSQL_ROOT_PASSWORD} DATABASE > backup.sql
