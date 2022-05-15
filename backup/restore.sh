export $(xargs < .env)

cat backup.sql | docker exec -i CONTAINER /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD} DATABASE
