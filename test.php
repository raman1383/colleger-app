<?php

// MySQL database configuration
$servername = "localhost";
$username = "college6_main";
$password = "QJXxbpy4aCW78xtaj6PH";
$database = "college6_main";

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Fetch data based on query
$query = $_POST['query'];
$result = $conn->query($query);

// Check if query was successful
if ($result) {
    $data = array();

    // Fetch associative array
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }

    // Free result set
    $result->free();

    // Close connection
    $conn->close();

    // Return data as JSON
    header('Content-Type: application/json');
    echo json_encode($data);
} else {
    // If query fails
    echo "Error: " . $conn->error;
}

?>
