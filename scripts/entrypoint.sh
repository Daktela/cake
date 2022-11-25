#!/bin/sh

BLUE='\033[0;34m'
NC='\033[0m' # No Color

set -e

case $1 in

  create)
      composer create-project --no-interaction --prefer-dist cakephp/app:"$2" .
    ;;

  create-and-up)
      printf "${BLUE}Creating project.${NC}\n"

      composer create-project --no-interaction --prefer-dist cakephp/app:"$2" .

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

  *)
      exec "$@"
    ;;

esac
