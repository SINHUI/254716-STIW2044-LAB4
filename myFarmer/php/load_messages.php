<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];


$sql = "SELECT * FROM MESSAGES WHERE SENDER = '$email'";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["messages"] = array();
    while ($row = $result ->fetch_assoc()){
        $msjlist = array();
        $msjlist[receiver] = $row["RECEIVER"];
        $msjlist[message] = $row["MESSAGE"];
        $msjlist[date] = $row["DATE"];
        array_push($response["messages"], $msjlist);    
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

?>