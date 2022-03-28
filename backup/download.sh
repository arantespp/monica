export $(xargs < .env)

aws s3 cp s3://${AWS_BUCKET}/_backups/monica.sql ./backup/monica.sql

