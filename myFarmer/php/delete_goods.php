<?php
error_reporting(0);
include_once("dbconnect.php");
$goodsid = $_POST['goodsid'];
$sql     = "DELETE FROM GOODS WHERE goodsid = $goodsid";
    if ($conn->query($sql) === TRUE){
        echo "success";
    }else {
        echo "failed";
    }

$conn->close();
?>