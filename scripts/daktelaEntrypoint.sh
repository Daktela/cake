#!/usr/bin/env sh
set -e

BLUE='\033[0;34m'
NC='\033[0m' # No Color

mkdir -p ./tmp
mkdir -p ./logs

composer install --prefer-dist --no-interaction --classmap-authoritative
composer dump-autoload --optimize
composer clear-cache --quiet

printf "${BLUE}Composer ready!\n${NC}"

echo "
  <?php
    \$dsn['$MYSQL_DATABASE'] = [
        'dsn' => 'mysql:host=$MYSQL_HOST:3306;dbname=$MYSQL_DATABASE',
        'database' => '$MYSQL_DATABASE',
        'user' => '$MYSQL_USER',
        'pass' => '$MYSQL_PASSWORD'
    ];
  " > /tmp/databases.php

php /usr/local/bin/wait-for-mysql.php

printf "${BLUE}Database connection ready!\n${NC}"

./bin/cake migrations migrate -vvv

printf "${BLUE}Database migrations ready!\n${NC}"

php /usr/local/bin/wait-for-mysql.php

printf "${BLUE}Database ready!\n${NC}"

yarn install --frozen-lockfile

printf "${BLUE}Yarn install done!\n${NC}"

./bin/cake cache clear_all

printf "${BLUE}Cake cache cleared!\n${NC}"