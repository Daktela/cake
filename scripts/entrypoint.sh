#!/bin/bash

set -e

case $1 in

  create)
      composer create-project --no-interaction --prefer-dist cakephp/app:"$2" .
    ;;

  serve)
      php-fpm -D
      nginx -g "daemon off;"

      fpm_pid=$(cat /run/php-fpm/php-fpm.pid)

      kill "$fpm_pid"
      echo Stopped php-fpm pid: "$fpm_pid"
    ;;

  up)
      echo "Bringing project up."

      /usr/local/bin/daktelaEntrypoint.sh

      echo "Starting webserver."

      php-fpm -D
      nginx -g "daemon off;"
  ;;

  *)
      exec "$@"
  ;;

esac
