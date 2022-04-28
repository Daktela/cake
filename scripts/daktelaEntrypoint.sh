#!/usr/bin/env sh

mkdir -p ./tmp
mkdir -p ./logs

composer install --prefer-dist --no-interaction --classmap-authoritative
composer dump-autoload --optimize
composer clear-cache --quiet

echo "Composer ready!"

echo "
  <?php
    \$dsn['$MYSQL_DATABASE'] = [
        'dsn' => 'mysql:host=DaktelaLabsMySQL:3306;dbname=$MYSQL_DATABASE',
        'database' => '$MYSQL_DATABASE',
        'user' => '$MYSQL_USER',
        'pass' => '$MYSQL_PASSWORD'
    ];
  " > /tmp/databases.php

php /tmp/wait_for_mysql.php

echo "Database connection ready!"

./bin/cake migrations migrate -vvv

echo "Database migrations ready!"

php /tmp/wait_for_mysql.php

echo "Database ready!"

yarn install --frozen-lockfile

echo "Yarn install done!"

./bin/cake cache clear_all

echo "Cake cache cleared!"