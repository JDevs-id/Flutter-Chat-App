<?php
include "conn.php";

$username = $_POST['username'];
$password = $_POST['password'];

$queryResult = $conn->query("SELECT * FROM `tb_user` WHERE `username`='$username' AND `password`='$password'");

$result = array();

while ($fetchData = $queryResult->fetch_assoc()) {
    $result[] = $fetchData;
}

echo json_encode($result);
