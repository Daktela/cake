#!/usr/bin/env sh
set -e

BLUE='\033[0;34m'
NC='\033[0m' # No Color

mkdir -p ./tmp
mkdir -p ./logs

composer install --prefer-dist --no-interaction --classmap-authoritative
composer dump-autoload --optimize
composer clear-cache --quiet

printf "${BLUE}Composer ready!${NC}\n"

php /usr/local/bin/wait-for-mysql.php

printf "${BLUE}Database connection ready!${NC}\n"

cake migrations migrate -vvv

printf "${BLUE}Database migrations ready!${NC}\n"

php /usr/local/bin/wait-for-mysql.php

printf "${BLUE}Database ready!${NC}\n"

yarn install --frozen-lockfile

printf "${BLUE}Yarn install done!${NC}\n"

cake cache clear_all

printf "${BLUE}Cake cache cleared!${NC}\n"
