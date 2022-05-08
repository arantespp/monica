# Monica

## Setup MySQL database

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

Access the container, create the database and the user, and,restore data:

```sh
docker exec -it mysql bash
mysql -u root -p"<password>"
CREATE DATABASE monica;
CREATE USER 'monica'@'%' IDENTIFIED BY 'monicapassword';
GRANT ALL PRIVILEGES ON monica.* TO 'monica'@'%';
FLUSH PRIVILEGES;
EXIT
mysql -u monica -p"monicapassword" monica < monica.sql
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

## Setup Monica

We've followed the instructions on [this example](https://github.com/monicahq/docker/tree/main/.examples/supervisor/fpm-alpine/app) to make Monica supervisor works to send automatic notifications and reminders.

## Environment variables

https://github.com/monicahq/monica/blob/main/.env.example

### Monica Fallback

We've also created a fallback for Monica container to help us debug eventual issues. For example, if HTTPS Gateway Timeout occurs and Monica fallback is working, we can assume that the issue should be on Traefik.

Add `MONICA_FALLBACK_PORT` to the `.env` file. This way you can access Monica over HTTP on $MONICA_URL:$MONICA_FALLBACK_PORT.

Don't forget to allow the fallback port on EC2 security group.

## Setup Traefik

Configure [Traefik dashboard secure](https://doc.traefik.io/traefik/operations/dashboard/) adding the following commands to the `.env` file:

- `TRAEFIK_URL`: The URL of the Traefik dashboard. You should configure it on your DNS provider.
- `TRAEFIK_BASIC_AUTH`: Execute the command `echo $(htpasswd -nb USER PASSWORD) | sed -e s/\\$/\\$\\$/g` to generate the basic auth credentials ((reference)[https://stackoverflow.com/a/62177819/8786986]).

## Start

Once you've configured the environment variables, you can start the containers:

```sh
sh start.sh
```
