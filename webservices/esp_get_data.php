<?php
  $local_mysql_address = 'localhost';
  $db_user = '';
  $db_password = '';
  $db_name = '';

    $conn = new mysqli($local_mysql_address, $db_user, $db_password, $db_name)
    or die ('Cannot connect to db');

  if(!empty($_GET["records"])) {
    $num_records = $_GET["records"];
  } else {
    $num_records = 1;
  }

  $query_string = "SELECT * FROM (SELECT * FROM test ORDER BY id DESC LIMIT ".$num_records.") sub ORDER BY id ASC";
  $result = mysqli_query($conn, $query_string);
  $result_array = array();

  while($row = $result->fetch_assoc()) {
    header('Content-type: application/json');
    array_push($result_array, $row);
  }
  echo json_encode($result_array);
  mysqli_close($conn);
?>
