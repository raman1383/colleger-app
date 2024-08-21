<!-- <?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
$ftpServer = "dl.colleger.ir";
$ftpUsername = "colleger@dl.colleger.ir";
$ftpPassword = "Qwer....1234";
$remoteFilePath = "/imageeeeeeeee.jpg"; // Replace with the desired path on the FTP server
$localFilePath = "colleger logo.jpg"; // Replace with the local path to your image

// Connect to FTP server
$ftpConnection = ftp_connect($ftpServer);
if (!$ftpConnection) {
    die("Could not connect to FTP server");
}

// Login to FTP server
$loginResult = ftp_login($ftpConnection, $ftpUsername, $ftpPassword);
if (!$loginResult) {
    die("FTP login failed");
}

ftp_pasv($ftpConnection, true);

// Upload the file
$uploadResult = ftp_put($ftpConnection, $remoteFilePath, $localFilePath, FTP_BINARY);

// Check for successful upload
if ($uploadResult) {
    echo "File uploaded successfully";
} else {
    echo "Error uploading file";
}

// Close FTP connection
ftp_close($ftpConnection);

?> -->

<?php
$ftp_server = "dl.colleger.ir";
$ftp_username = "colleger@dl.colleger.ir";
$ftp_password = "Qwer....1234";
$ftp_dir = "/";

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['image'])) {
    $file = $_FILES['image'];

    $file_name = $file['name'];
    $file_temp = $file['tmp_name'];

    $ftp_connection = ftp_connect($ftp_server);
    ftp_login($ftp_connection, $ftp_username, $ftp_password);
    
    if (ftp_put($ftp_connection, $ftp_dir . $file_name, $file_temp, FTP_BINARY)) {
        echo "File uploaded successfully.";
    } else {
        echo "Failed to upload file.";
    }

    ftp_close($ftp_connection);
} else {
    echo "Invalid request.";
}
?>
