FROM php:8.1-apache

RUN apt-get update && apt-get install -y apt-utils && a2enmod rewrite && a2enmod headers

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && install-php-extensions bcmath pgsql pdo_pgsql gd zip intl redis

COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Install composer from the official image
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Run composer install to install the dependencies
#RUN composer install --optimize-autoloader --no-interaction

WORKDIR /var/www/html

RUN usermod -u 1000 www-data

EXPOSE 8080
