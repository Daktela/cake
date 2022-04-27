#!/bin/bash

set -e

[ -s /run/php-fpm/php-fpm.pid ] || php-fpm -D

case $1 in

  create)
      composer create-project --no-interaction --prefer-dist cakephp/app:$2 .
    ;;

  serve)
      nginx -g "daemon off;"
    ;;

  *)
      exec "$@"
    ;;

esac
