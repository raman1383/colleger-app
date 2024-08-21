<?php

// Database connection parameters
$servername = "localhost";
$username = "college6_users_info";
$password = "pXYjAqhtyrwbtB9dhuep";
$database = "college6_users_info";

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get SQL query from request
// $query = $_POST['query']; // Assuming the query is sent via POST request

$query = "CREATE TABLE test(
    id INT,
    name VARCHAR(20)
);";

// Perform query
$result = $conn->query($query);

if (!$result) {
    echo "Error executing query: " . $conn->error;
} else {
    // Fetch result and output
    $rows = array();
    while ($row = $result->fetch_assoc()) {
        $rows[] = $row;
    }
    echo json_encode($rows); // Output result as JSON
}

// Close connection
$conn->close();

?>
