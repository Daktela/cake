FROM daktela/php-fpm:8.1

# Install PHP and other packages

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache nginx git curl nodejs npm yarn

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

COPY ./config/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./config/php/php-ini-xdebug.ini /etc/php81/conf.d/50-xdebug.ini

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

ENV PROJECT_ROOT="/var/www/html/"
ENV OWNER="www-data:www-data"

RUN mkdir -p $PROJECT_ROOT && \
	mkdir -p /var/lib/nginx/ &&\
    mkdir -p /var/log/nginx/ &&\
    mkdir -p /run/nginx/ &&\
    mkdir -p /home/www/ &&\
    chown $OWNER -R ${PROJECT_ROOT} &&\
    chown $OWNER -R /var/log/nginx && \
    chown $OWNER -R /var/lib/nginx && \
    chown $OWNER -R /run/nginx/ && \
    chown $OWNER -R /var/log/php81/ && \
    chown $OWNER -R /home/www/ && \
    chown $OWNER -R /run/php-fpm/

WORKDIR $PROJECT_ROOT

ENV PATH="/var/www/html/bin/:$PATH"

ADD ./config/cake/app_local.example.php /tmp

# Prepare entrypoint
ADD ./scripts/entrypoint.sh /usr/local/bin/
ADD ./scripts/daktelaEntrypoint.sh /usr/local/bin/
ADD ./scripts/wait-for-mysql.php /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/daktelaEntrypoint.sh
RUN chmod +x /usr/local/bin/wait-for-mysql.php

RUN ln /usr/local/bin/entrypoint.sh /usr/local/bin/project

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 80

CMD ["serve"]
