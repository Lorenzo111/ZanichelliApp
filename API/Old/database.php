<?php
// used to connect to the database
$host = "188.121.57.61";
$db_name = "zanichelliDB";
$username = "zanichelliDB";
$password = "Zanichelli2018#";
  
try {
    $con = new PDO("mysql:host={$host};dbname={$db_name}", $username, $password);
}
  
// show error
catch(PDOException $exception){
    echo "Connection error: " . $exception->getMessage();
}
?>