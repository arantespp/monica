export $(xargs < .env)

# NOT TESTED!!!

cat backup.sql | docker exec -i mysql /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD}



