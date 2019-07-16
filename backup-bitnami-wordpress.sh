#!/bin/bash

SETLOCAL ENABLEEXTENSIONS

# Backup Bitnami Wordpress blog, and transfer it to AWS S3 (optional)
# Usage: backup-bitnami.sh
# Prerequisites: aws cli has been setup: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html

SITE_ROOT="/opt/bitnami"
SITE_NAME="bitnami-wordpress"
S3_BUCKET="family-blog"

if [ "$#" -ge "1" ] ; then SITE_NAME=$1; fi
FILE_NAME=$SITE_NAME-`date +%F`.tar.gz

sudo /opt/bitnami/ctlscript.sh stop
echo `date +"%F %r"`: Stopped Wordpress.

sudo tar -pczf $FILE_NAME $SITE_ROOT
echo `date +"%F %r"`: Packaged and compressed Wordpress $FILE_NAME.

sudo /opt/bitnami/ctlscript.sh start &
echo `date +"%F %r"`: Starting Wordpress.

if [ "$S3_BUCKET" !=  "" ]
then
    aws s3 cp $FILE_NAME s3://$S3_BUCKET/backup/ --storage-class REDUCED_REDUNDANCY
    if [ "0" -eq "$?" ]
    then
        echo `date +"%F %r"`: Uploaded $FILE_NAME to S3 $S3_BUCKET.
        sudo rm $FILE_NAME
        echo `date +"%F %r"`: Removed local file $FILE_NAME.
    fi
fi