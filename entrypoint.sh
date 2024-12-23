#!/bin/bash

generate_index() {
    echo "Generating opkg package index..."
    cp -r /packages/* /var/www/html/
    rm -f /var/www/html/Packages*
    opkg-make-index -p /var/www/html/Packages /var/www/html
    echo "Index generated."
}

generate_index

echo "Starting Nginx..."
exec "$@" &

echo "Watching /packages for changes..."
inotifywait -m -e create,delete,modify,move /packages | while read -r directory events filename; do
    echo "Change detected in /packages: $events $filename"
    generate_index
done