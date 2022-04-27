#!/bin/bash

#set -e

case $1 in

  create)
      composer create-project --no-interaction --prefer-dist cakephp/app:$2 .
    ;;

  serve)
      php-fpm -D
      nginx -g "daemon off;"
    ;;

  *)
      exec "$@"
    ;;

esac
