<!-- <?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
$ftpServer = "dl.colleger.ir";
$ftpUsername = "colleger@dl.colleger.ir";
$ftpPassword = "Qwer....1234";
$remoteFilePath = "/imageeeeeeeee.jpg"; // Replace with the path of the file on the FTP server
$localFilePath = "downloaded_image.jpg"; // Replace with the desired local path for the downloaded file

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

// Download the file
$downloadResult = ftp_get($ftpConnection, $localFilePath, $remoteFilePath, FTP_BINARY);

// Check for successful download
if ($downloadResult) {
    echo "File downloaded successfully";
} else {
    echo "Error downloading file";
}

// Close FTP connection
ftp_close($ftpConnection);

?> -->


<?php
$ftp_server = "dl.colleger.ir";
$ftp_username = "colleger@dl.colleger.ir";
$ftp_password = "Qwer....1234";
$ftp_dir = "/";

if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['filename'])) {
    $file_name = $_GET['filename'];

    $ftp_connection = ftp_connect($ftp_server);
    ftp_login($ftp_connection, $ftp_username, $ftp_password);
    
    $local_file = fopen($file_name, 'w');

    if (ftp_fget($ftp_connection, $local_file, $ftp_dir . $file_name, FTP_BINARY)) {
        echo "File downloaded successfully.";
    } else {
        echo "Failed to download file.";
    }

    fclose($local_file);
    ftp_close($ftp_connection);
} else {
    echo "Invalid request.";
}
?>
