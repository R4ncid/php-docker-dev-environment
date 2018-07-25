FROM php:7.0-apache

RUN apt-get update && apt-get install -y  zlib1g-dev git curl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "Europe/Rome"\n' > /usr/local/etc/php/conf.d/tzone.ini
RUN docker-php-ext-install  mysqli
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install zip
RUN docker-php-ext-install mbstring

ENV XDEBUG_PORT=9000
ENV XDEBUG_HOST=my-host
ENV XDEBUG_KEY=xdebug

RUN pecl install xdebug && docker-php-ext-enable xdebug
#RUN echo 'zend_extension="/usr/local/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so"' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_port=${XDEBUG_PORT}' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_host=${XDEBUG_HOST}' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_connect_back=0' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.idekey=${XDEBUG_KEY}' >> /usr/local/etc/php/php.ini


RUN usermod -u 1000 www-data
RUN a2enmod rewrite
RUN apachectl restart