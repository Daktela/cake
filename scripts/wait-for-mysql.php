<?php

$dsn = [];

if (file_exists('/tmp/databases.php')) {
    include '/tmp/databases.php';
} else {

    require('vendor/autoload.php');
    
    $dotenv = new \josegonzalez\Dotenv\Loader(['.env']);
    $dotenv = $dotenv->parse()->toArray();

    $dsn[$dotenv['MYSQL_DATABASE']] = [
        'dsn' => 'mysql:host=' . $dotenv["MYSQL_HOST"] . ':3306;dbname=' . $dotenv["MYSQL_DATABASE"],
        'database' => $dotenv['MYSQL_DATABASE'],
        'user' => $dotenv['MYSQL_USER'],
        'pass' => $dotenv['MYSQL_PASSWORD']
    ];
}

$connections = [];
$checked = [];

while (count($connections) != count($dsn) && count($checked) != count($dsn)) {

    foreach ($dsn as $name => $_dsn) {
        try {
            $dbh = new pdo(
                $_dsn['dsn'], $_dsn['user'], $_dsn['pass'],
                array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION)
            );

            echo "\e[32mDatabase $name is ready \n";
            $connections[$name] = true;
            if (!isset($checked[$name])) {
                $stmt = $dbh->query("SHOW TABLES FROM " . $_dsn['database']);
                while ($row = $stmt->fetch()) {
                    $dbh->query("CHECK TABLE " . $row[0]);
                    echo "\e[33mCheck table " . $_dsn['database'] . "." . $row[0] . " done \n";
                }
                $checked[$name] = true;
            }

        } catch (PDOException $ex) {
            error_log("\e[31mWaiting for $name database");
            sleep(5);
        }
    }
}
