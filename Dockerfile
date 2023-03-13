FROM php:8.1-apache

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils && a2enmod rewrite && a2enmod headers

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && install-php-extensions bcmath pgsql pdo_pgsql gd zip intl redis

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
	&& apt-get install -y nodejs \
	&& apt-get install -y gcc g++ make \
	&& curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null \
	&& echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list \
	&& apt-get update && apt-get install -y yarn

#RUN apt-get install supervisor && systemctl start supervisor.service && sydtemctl enable supervisor.service

COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

#COPY ./queue-listen.conf /etc/supervisor/conf.d/

#RUN /usr/bin/supervisord -c /etc/supervisor/conf.d/queue-listen.conf

COPY ./app /var/www/html

# Install composer from the official image
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Run composer install to install the dependencies
#RUN composer install --optimize-autoloader --no-interaction

WORKDIR /var/www/html

RUN usermod -u 1000 www-data && chown -R www-data:www-data /var/www/html

EXPOSE 80
