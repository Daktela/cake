FROM daktela/php-fpm:8.1


# Install PHP and other packages
RUN dnf -q -y update && \
    dnf -q -y install nginx php-xdebug npm && \
    dnf clean all && \
    npm install -g yarn

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Prepare entrypoint
ADD ./scripts/entrypoint.sh /usr/local/bin/
ADD ./scripts/daktelaEntrypoint.sh /usr/local/bin/
ADD ./scripts/wait-for-mysql.php /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/daktelaEntrypoint.sh
RUN chmod +x /usr/local/bin/wait-for-mysql.php

COPY ./config/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./config/php/php-ini-xdebug.ini /etc/php.d/15-xdebug.ini

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

ENV PROJECT_ROOT="/var/www/html/"

ENV XDEBUG_HOST=host.docker.internal
ENV XDEBUG_LOG_LEVEL=1
ENV XDEBUG_MODE="off"

RUN mkdir -p /var/lib/nginx/ &&\
    mkdir -p /var/log/nginx/ &&\
    mkdir -p /run/nginx/ &&\
    chown ${USER_NAME}:${USER_GROUP} -R ${PROJECT_ROOT} &&\
    chown ${USER_NAME}:${USER_GROUP} -R /var/log/nginx && \
    chown ${USER_NAME}:${USER_GROUP} -R /var/lib/nginx && \
    chown ${USER_NAME}:${USER_GROUP} -R /run/nginx/ && \
    chown ${USER_NAME}:${USER_GROUP} -R /var/log/php-fpm/ && \
    chown ${USER_NAME}:${USER_GROUP} -R /run/php-fpm/

WORKDIR $PROJECT_ROOT

ENV PATH="/var/www/html/bin/:$PATH"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 80

CMD ["serve"]
