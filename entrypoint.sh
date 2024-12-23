#!/bin/bash

# Generate the opkg index for the /packages volume
echo "Generating opkg package index..."
cp -r /packages/* /var/www/html/
opkg-make-index -p /var/www/html/Packages /var/www/html
echo "Index generated."

# Start Nginx
echo "Starting Nginx..."
exec "$@"
