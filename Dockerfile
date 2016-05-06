FROM php:7.0-apache
RUN a2enmod rewrite  
RUN apt-get update && apt-get install git libpq-dev libldap2-dev rxvt-unicode -y && \
    ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so && \
    docker-php-ext-install pdo_pgsql ldap zip && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');"    	

COPY composer.json /var/www/html/composer.json
WORKDIR /var/www/html
RUN ./composer.phar install --prefer-dist -vvv --profile
COPY default.conf /etc/apache2/sites-enabled/default.conf
COPY bashrc /root/.bashrc
