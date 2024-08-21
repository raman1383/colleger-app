<?php


// Database connection parameters
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

// Function to execute SQL query and print results
function executeQuery($conn, $sql) {
    $result = $conn->query($sql);

    if ($result === false) {
        echo "Error executing query: " . $conn->error;
        return;
    }

    if ($result->num_rows > 0) {
        // Print column names
        $fields = $result->fetch_fields();
        foreach ($fields as $field) {
            echo $field->name . "\t";
        }
        echo "\n";

        // Print rows
        while ($row = $result->fetch_assoc()) {
            foreach ($row as $value) {
                echo $value . "\t";
            }
            echo "\n";
        }
    } else {
        echo "No results found.";
    }
}

// Example SQL query
$sql = "USE college6_users_basic;CREATE TABLE users_basic (
    user_id INT NOT NULL AUTO_INCREMENT ,
    user_name VARCHAR(255) NOT NULL UNIQUE,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(11) NOT NULL,
    birth_date DATE NOT NULL,
    gender_is_male BOOLEAN NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    height INT,
    weight INT,
    location POINT,
    verified ENUM('none','pending','verified') NOT NULL,
    desirability_score INT NOT NULL, 
    roses_count INT,
    subscription_tier ENUM('min','max'),
    ref_to_pics INT NOT NULL UNIQUE,
    ref_to_audio INT NOT NULL UNIQUE,
    ref_to_prompts INT NOT NULL UNIQUE,
    ref_to_chats INT NOT NULL UNIQUE,
     
    
    PRIMARY KEY(user_id),
    FOREIGN KEY (ref_to_pics) REFERENCES pics(pic_id),
    FOREIGN KEY (ref_to_audio) REFERENCES audios(audio_id),
    FOREIGN KEY (ref_to_prompts) REFERENCES prompts(prompt_id),
    FOREIGN KEY (ref_to_chats) REFERENCES chats(chat_id)
    );";

// Execute the query
executeQuery($conn, "SELECT (liker_id) FROM likes WHERE likee_id=11 LIMIT 99;");

// Close connection
$conn->close();

?>
