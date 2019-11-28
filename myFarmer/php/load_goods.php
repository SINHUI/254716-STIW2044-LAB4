<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];


$sql = "SELECT * FROM GOODS WHERE GOODSWORKER IS NULL ORDER BY GOODSID DESC";

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
        $goodslist[goodstime] = date_format(date_create($row["GOODSTIME"]), 'd/m/Y h:i:s');
        $goodslist[goodsimage] = $row["GOODSIMAGE"];
        $goodslist[goodslatitude] = $row["LATITUDE"];
        $goodslist[goodslongitude] = $row["LONGITUDE"];
        $goodslist[km] = distance($latitude,$longitude,$row["LATITUDE"],$row["LONGITUDE"]);
        $goodslist[goodsrating] = $row["RATING"];
        //$goodslist[radius] = $row["LATITUDE"];
       // if (distance($latitude,$longitude,$row["LATITUDE"],$row["LONGITUDE"])<$radius){
            array_push($response["goods"], $goodslist);    
        //}
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

function distance($lat1, $lon1, $lat2, $lon2) {
   $pi80 = M_PI / 180;
    $lat1 *= $pi80;
    $lon1 *= $pi80;
    $lat2 *= $pi80;
    $lon2 *= $pi80;

    $r = 6372.797; // mean radius of Earth in km
    $dlat = $lat2 - $lat1;
    $dlon = $lon2 - $lon1;
    $a = sin($dlat / 2) * sin($dlat / 2) + cos($lat1) * cos($lat2) * sin($dlon / 2) * sin($dlon / 2);
    $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
    $km = $r * $c;

    //echo '<br/>'.$km;
    return $km;
}

?>