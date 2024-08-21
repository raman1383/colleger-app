<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
$sql = $_POST["sqlQuery"];
$conn = new mysqli("localhost", "colleger_test_mysql_1", "Qwer....1234", "colleger_test_mysql_1");
if ($conn->connect_error){die("Connection failed: " . $conn->connect_error);}
$result = $conn->query($sql);
echo "done";
$conn->close();
?>