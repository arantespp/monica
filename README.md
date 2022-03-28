# Monica

## Environment variables

https://github.com/monicahq/monica/blob/main/.env.example

## Initiate MySQL database

```sh
docker-compose up mysql
```

### Restoring database

Download the backup file from your S3 bucket:

```sh
sh backup/download.sh
```

Copy the backup file to the MySQL container:

```sh
docker cp ./backup/monica.sql mysql:/
```

Access the container and restore the database:

```sh
docker exec -it mysql bash
mysql -u root -p"<password>"
CREATE DATABASE monica;
EXIT
mysql -u root -p"<password>"  monica < monica.sql
```

Create Monica user and grant all privileges of `monica` database:

```mysql
CREATE USER 'monica'@'%' IDENTIFIED BY 'monicapassword';
GRANT ALL PRIVILEGES ON monica.* TO 'monica'@'localhost';
FLUSH PRIVILEGES;
```

Add the following lines to the `.env` file:

```
MONICA_DB_DATABASE=monica
MONICA_DB_USERNAME=monica
MONICA_DB_PASSWORD=monicapassword
```

Remove 2FA from old users ([reference](https://github.com/monicahq/monica/issues/5235)):

```sh
mysql -u monica -p monicapassword
use monica;
SELECT id,first_name,google2fa_secret FROM users;
UPDATE users SET google2fa_secret=NULL WHERE id=USER_ID;
```
