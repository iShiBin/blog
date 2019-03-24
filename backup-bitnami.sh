#!/bin/bash

# Backup Bitnami Wordpress blog, and transfer it to remote host.
# Usage: backup-bitnami.sh site-name <remote-host>:<backup-directory>
# Prerequisites: The local host can ssh to the remote without password.
# (https://linuxize.com/post/how-to-setup-passwordless-ssh-login/)

SITE_ROOT="/opt/bitnami/scripts"
SITE_NAME="bitnami-wordpress"

if [ "$#" -ge "1" ] ; then SITE_NAME=$1; fi
FILE_NAME=$SITE_NAME-`date +%F`.tar.gz

sudo /opt/bitnami/ctlscript.sh stop
echo `date +"%F %r"`: Stopped Wordpress.

sudo tar -pczf $FILE_NAME $SITE_ROOT
echo `date +"%F %r"`: Packaged and compressed Wordpress $FILE_NAME.

if [ $# -ge 2 ]
then
    REMOTE_DIR=$2
    scp $FILE_NAME $REMOTE_DIR
    echo `date +"%F %r"`: Delivered the backup file to remote host $REMOTE_DIR.
    if [ "0" -eq "$?" ]
    then
        sudo rm $FILE_NAME
        echo `date +"%F %r"`: Removed local file $FILE_NAME.
    fi
fi
