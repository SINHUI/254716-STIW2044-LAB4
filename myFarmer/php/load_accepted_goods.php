<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM GOODS WHERE GOODSWORKER = '$email' ORDER BY GOODSID DESC";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["goods"] = array();
    while ($row = $result ->fetch_assoc()){
        $goodslist = array();
        $goodslist[goodsid] = $row["GOODSID"];
        $goodslist[goodstitle] = $row["GOODSTITLE"];
        $goodslist[goodsowner] = $row["GOODSOWNER"];
        $goodslist[goodsprice] = $row["GOODSPRICE"];
        $goodslist[goodsdesc] = $row["GOODSDESC"];
        $goodslist[goodstime] = date_format(date_create($row["pGOODSTIME"]), 'd/m/Y h:i:s');
        $goodslist[goodsimage] = $row["GOODSIMAGE"];
        $goodslist[goodslatitude] = $row["LATITUDE"];
        $goodslist[goodslongitude] = $row["LONGITUDE"];
        $goodslist[goodsrating] = $row["RATING"];
        array_push($response["goods"], $goodslist);    
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

?>