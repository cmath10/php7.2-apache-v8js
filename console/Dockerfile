FROM php7.2-apache-v8js

WORKDIR /var/www/php7.2-apache-v8js

COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

RUN useradd -m -U -s /bin/bash hostuser

RUN chown hostuser:hostuser /var/www

ENTRYPOINT ["entrypoint.sh"]
