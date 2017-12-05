<?php

$local_mysql_address = 'localhost';
$db_user = '';
$db_password = '';
$db_name = '';
$value = "";

$conn = new mysqli($local_mysql_address, $db_user, $db_password, $db_name)
  or die ('Cannot connect to db');

$value = $_POST['value'];
$insert_string = "INSERT INTO test (value) VALUES('$value')";

mysqli_query($conn, $insert_string);
mysqli_close($conn);

?>
