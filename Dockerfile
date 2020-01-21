FROM php:7-apache
MAINTAINER tom@tomfern.com
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY start-apache /usr/local/bin
RUN a2enmod rewrite
RUN apt-get update && apt-get install -y libonig-dev ruby-dev rubygems && gem install oniguruma
RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
		libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install mbstring \
	&& docker-php-ext-install mcrypt
COPY src /var/www/
RUN chown -R www-data:www-data /var/www
CMD ["start-apache"]
