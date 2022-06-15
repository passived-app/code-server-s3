#!/bin/sh -e

mkdir -p ${PWD}/script

echo $ACCESS_KEY:$SECRET_KEY > /home/coder/.passwd-s3fs
chmod 600 /home/coder/.passwd-s3fs

s3fs $BUCKET_NAME $PWD/script -o allow_other -o passwd_file=/home/coder/.passwd-s3fs -o use_path_request_style -o endpoint=$S3_REGION -o parallel_count=15 -o multipart_size=128 -o nocopyapi -o url=$S3_URL

sh /usr/bin/entrypoint.sh --bind-addr 0.0.0.0:8080 $PWD

