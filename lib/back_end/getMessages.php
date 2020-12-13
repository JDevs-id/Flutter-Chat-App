<?php
include 'conn.php';

$username = $_GET['username'];

$queryResult = $conn->query("SELECT * FROM `tb_messages` INNER JOIN `log_messages` ON `tb_messages`.message_id=`log_messages`.message_id WHERE `tb_messages`.`sender`='$username' OR `tb_messages`.`receiver`='$username'");
$result = array();

while ($fetchData = $queryResult->fetch_assoc()) {
    $result[] = $fetchData;
}

echo json_encode($result);
