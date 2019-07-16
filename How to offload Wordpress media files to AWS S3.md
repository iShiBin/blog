# How to offload Wordpress media files to AWS S3

The wordpress host I used in AWS Lightsail only has 40GB disk space. It easily run out bhe ecause I have a lot of photos. So I use `WP Offload Media Lite` to offload the media files to S3. However, the prolem with this plugin is it only applied for future media files. And it causes quite a fortune (>80$) to buy the pro version. Instead, I write some script to easily move the files to S3.

## Step 0: Install and config `WP Offload Media Lite`

## Step 1: Upload existing media files to S3.

I developed this script `offload_wordpress_media.py` to achieve this. You can run it using:

> ./offload_wordpress_media.py ~/apps/wordpress/htdocs/wp-content/uploads s3-blog-bucket

## Step 2: Replace the media URLs in all posts.

Login to the the Php admin page,  goto Server > Database > Table: wp_posts, and then replace:

`http://<your.web.site>/wp-content/uploads/`with the new S3 URL `https://<s3-bucket>.s3-<region-name>.amazonaws.com/wp-content/uploads/` for all the posts.

## Step 3: Install and configure ‘Regenerate Thumbnails’ plugin

## Optional
* Create a cron job to automatically backup and upload the backup to S3.
* Create an S3 rule to transit the S3 to One zone-IA to save some money.

Reference: https://www.joe0.com/2017/03/13/how-to-move-wordpress-images-to-amazon-s3-free-solution/
