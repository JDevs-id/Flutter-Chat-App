<?php
include 'conn.php';

$queryResult=$conn->query("SELECT * FROM `tb_user` WHERE `status`='login'");
$result=array();

while($fetchData=$queryResult->fetch_assoc()){
    $result[]=$fetchData;
}

echo json_encode($result);
