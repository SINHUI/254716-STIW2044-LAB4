<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$password = $_POST['password'];
$phone = $_POST['phone'];
$name = $_POST['name'];
$radius = $_POST['radius'];

$usersql = "SELECT * FROM USER WHERE EMAIL = '$email'";

if (isset($name) && (!empty($name))){
    $sql = "UPDATE USER SET NAME = '$name' WHERE EMAIL = '$email'";
}
if (isset($password) && (!empty($password))){
    $sql = "UPDATE USER SET PASSWORD = sha1($password) WHERE EMAIL = '$email'";
}
if (isset($radius)&& (!empty($radius))){
    $sql = "UPDATE USER SET RADIUS = '$radius' WHERE EMAIL = '$email'";
}
if (isset($phone) && (!empty($phone))){
    $sql = "UPDATE USER SET PHONE = '$phone' WHERE EMAIL = '$email'";
}

if ($conn->query($sql) === TRUE) {
    $result = $conn->query($usersql);
if ($result->num_rows > 0) {
        while ($row = $result ->fetch_assoc()){
        echo "success,".$row["NAME"].",".$row["EMAIL"].",".$row["PHONE"].",".$row["RADIUS"].",".$row["CREDIT"].",".$row["RATING"].",".$row["DATE"];
        }
    }else{
        echo "failed,null,null,null,null,null,null,null";
    }
} else {
    echo "error";
}

$conn->close();
?>
