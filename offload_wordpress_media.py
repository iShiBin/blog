#!/usr/bin/python3

""""
Upload wordpress/htdocs/wp-content/uploads from locallost to AWS S3 bucket to save server disk space.
This supposed to be run once and the future media files could be uploaded by Wordpress plugin: Offload Media Lite

Prerequirements:
* Install and configure boto3 https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html#configuration
* Create the desitnation S3 bucket.
"""

import os
import sys
import argparse
import logging

import boto3
from botocore.exceptions import ClientError

def upload_file(file_name, bucket, object_name=None):
    """Upload a file to an S3 bucket

    :param file_name: File to upload
    :param bucket: Bucket to upload to
    :param object_name: S3 object name. If not specified then file_name is used
    :return: True if file was uploaded, else False
    """

    # If S3 object_name was not specified, use file_name
    if object_name is None:
        object_name = file_name

    # Upload the file
    s3_client = boto3.client('s3')
    try:
        response = s3_client.upload_file(file_name, bucket, object_name)
    except ClientError as e:
        logging.error(e)
        return False
    return True


def main(src_dir, dest_bucket):
    """Upload all files in src_dir to S3 dest_bucket.
    """
    exceptions = []
    for root, dirs, files in os.walk(src_dir):
        for name in files:
            file_name = os.path.join(root, name)
            object_name = file_name[file_name.find('wp-content'):]
            if not upload_file(file_name, dest_bucket, object_name):
                exceptions.append(file_name)

    if len(exceptions) == 0:
        logging.info('All files in {} have been uploaded to {}.'.format(src_dir, dest_bucket))
    else:
        logging.error('The following files are not uploaded: ', exceptions)


if __name__ == '__main__':
    if len(sys.argv) == 3:
        src_dir = sys.argv[1]
        dest_bucket = sys.argv[2]
        main(src_dir, dest_bucket)
    else:
        src_dir = input('What is your wordpress media directory (such as %wordpress%/htdocs/wp-content/uploads):\n')
        dest_bucket = input('What is your destination S3 bucket:\n')
        main(src_dir, dest_bucket)
