#!/bin/sh

BLUE='\033[0;34m'
NC='\033[0m' # No Color

set -e

OWNER=www-data:www-data 

case $1 in

  create)
      composer create-project --no-interaction --prefer-dist cakephp/app:"$2" .
    ;;

  create-and-up)

      if [ -z "$(ls -A .)" ]; then
      	printf "${BLUE}Creating project.${NC}\n"

      	composer create-project --no-interaction --prefer-dist cakephp/app:"$2" .

        cp /tmp/app_local.example.php config/app_local.php

        SALT=$(tr -dc a-z0-9 </dev/urandom | head -c 64)

        sed -i "s/__SALT__/$SALT/g" config/app_local.php

        chown -R $OWNER .
        chmod -R 777 logs/

      fi
 
      printf "${BLUE}Starting webserver.${NC}\n"
	
      php-fpm81 -D
      nginx -g "daemon off;"

      fpm_pid=$(cat /run/php-fpm/php-fpm.pid)

      kill "$fpm_pid"
      echo Stopped php-fpm pid: "$fpm_pid"
    ;;

  serve)
      php-fpm81 -D
      nginx -g "daemon off;"

      fpm_pid=$(cat /run/php-fpm/php-fpm.pid)

      kill "$fpm_pid"
      echo Stopped php-fpm pid: "$fpm_pid"
    ;;

  up)

      printf "${BLUE}Bringing project up.${NC}\n"

      /usr/local/bin/daktelaEntrypoint.sh

      printf "${BLUE}Starting webserver.${NC}\n"

      php-fpm81 -D
      nginx -g "daemon off;"
    ;;

  permissions)
    chown -R $OWNER src/ config/ plugins/ templates/ tests/ webroot/
    ;;

  *)
      exec "$@"
    ;;

esac
