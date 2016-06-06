FROM php:7.0-apache
RUN a2enmod rewrite  
RUN apt-get update && apt-get install --no-install-recommends git libpq-dev libldap2-dev libmemcached-dev vim-tiny rxvt-unicode -y && \
    ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so && \
    docker-php-ext-install pdo_pgsql ldap zip && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get clean

RUN cd /usr/bin && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar composer && \
    chmod +x composer

RUN pecl install xdebug
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN cd /usr/local/src && \
    git clone https://github.com/php-memcached-dev/php-memcached.git && \
    cd php-memcached && git checkout php7 && \
    phpize && ./configure --disable-memcached-sasl && \
    make install && \
    echo "extension=memcached.so" >> /usr/local/etc/php/conf.d/memcached.ini && \
    rm -rf /usr/local/src/php-memcached

COPY composer.json /var/www/html/composer.json
WORKDIR /var/www/html
COPY default.conf /etc/apache2/sites-enabled/default.conf
COPY bashrc /root/.bashrc
