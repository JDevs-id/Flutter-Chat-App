<?php
include 'conn.php';

$username = $_POST['username'];
$status = $_POST['status'];
$sessions = $_POST['sessions'];

$conn->query("UPDATE `tb_users` SET `status` = '$status', `sessions` = $sessions WHERE `username` = '$username'");
