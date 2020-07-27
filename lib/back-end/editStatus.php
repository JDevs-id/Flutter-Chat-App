<?php
include 'conn.php';

$username = $_POST['username'];
$status = $_POST['status'];

$conn->query("UPDATE `tb_user` SET `status` = '$status' WHERE `tb_user`.`username` = '$username'");
