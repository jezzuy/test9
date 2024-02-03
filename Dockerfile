FROM php:8.2-apache

# Combine apt-get update and apt-get install
RUN apt-get update && \
    apt-get install -y \
        libzip-dev \
        libicu-dev \
        libpng-dev \
        libjpeg-dev \
        libgmp-dev \
        libssl-dev \
        libc-client-dev \
        libkrb5-dev && \
    rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install mysqli imap gd zip

# Set permissions and ownership for the web server

RUN chown -R www-data:www-data /var/www/html && \
    chmod 755 /var/www/html/uploads/ \
    && chmod 755 /var/www/html/application/config/ \
    && chmod 755 /var/www/html/application/config/config.php \
    && chmod 755 /var/www/html/application/config/app-config-sample.php \
    && chmod 755 /var/www/html/temp/

# Set PHP configuration
RUN echo "upload_max_filesize = 8M" > /usr/local/etc/php/conf.d/uploads.ini && \
    echo "post_max_size = 8M" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "memory_limit = 256M" >> /usr/local/etc/php/conf.d/uploads.ini

# Enable Apache modules
RUN a2enmod rewrite


# Restart Apache
RUN service apache2 restart
