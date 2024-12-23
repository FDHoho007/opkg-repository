# Use an official lightweight image as the base
FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    python3 \
    git \
    build-essential \
    perl \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install opkg-utils from source
RUN git clone https://git.yoctoproject.org/opkg-utils.git /tmp/opkg-utils \
    && make -C /tmp/opkg-utils install \
    && cp /tmp/opkg-utils/opkg-make-index /usr/local/bin \
    && rm -rf /tmp/opkg-utils

# Prepare Nginx configuration
RUN mkdir -p /packages /var/www/html /var/log/nginx \
    && chown -R www-data:www-data /var/www/html /var/log/nginx \
    && rm /var/www/html/index.nginx-debian.html
COPY nginx.conf /etc/nginx/sites-available/default

# Add an entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the Nginx HTTP port
EXPOSE 80

# Define volumes for package storage
VOLUME ["/packages"]

# Start the container
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
