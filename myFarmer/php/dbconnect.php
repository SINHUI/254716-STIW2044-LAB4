<?php
$servername = "localhost";
$username 	= "lastyear_myfarmer";
$password 	= "DqpHU9}UUnC_";
$dbname 	= "lastyear_myfarmer";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>