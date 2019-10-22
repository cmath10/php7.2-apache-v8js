FROM laravel-map-web


# NodeJS

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs


WORKDIR /var/www/laravel-map.local


# Composer

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer


# Configuration

RUN npm i -g npm


# Deployer (https://deployer.org)

RUN curl -LO https://deployer.org/releases/v6.4.3/deployer.phar && mv deployer.phar /usr/local/bin/dep && chmod +x /usr/local/bin/dep

EXPOSE 9876

COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

RUN useradd -m -U -s /bin/bash hostuser

RUN chown hostuser:hostuser /var/www

ENTRYPOINT ["entrypoint.sh"]
