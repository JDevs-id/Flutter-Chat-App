<?php
include 'conn.php';

$username = $_GET['username'];

$queryResult = $conn->query("SELECT * FROM `tb_users` WHERE `username`='$username'");
$result = array();

while ($fetchData = $queryResult->fetch_assoc()) {
    $result[] = $fetchData;
}

echo json_encode($result);
