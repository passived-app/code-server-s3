#!/bin/sh -e

sudo mkdir -p ${PWD}
sudo chown -R coder:coder ${PWD}

mkdir -p ${PWD}/script
sudo chown -R coder:coder ${PWD}/script

echo $ACCESS_KEY:$SECRET_KEY > /home/coder/.passwd-s3fs
chmod 600 /home/coder/.passwd-s3fs

if [[ -z "${S3_REGION}" ]]; then
  s3fs $BUCKET_NAME $PWD/script -o allow_other -o passwd_file=/home/coder/.passwd-s3fs $SPECIAL_PARAMS -o url=$S3_URL
else
  s3fs $BUCKET_NAME $PWD/script -o allow_other -o passwd_file=/home/coder/.passwd-s3fs $SPECIAL_PARAMS -o url=$S3_URL
fi

sh /usr/bin/entrypoint.sh --bind-addr 0.0.0.0:8080 $PWD

