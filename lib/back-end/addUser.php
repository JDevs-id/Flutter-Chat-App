<?php
include 'conn.php';

$username = $_POST['username'];
$password = $_POST['password'];
$status = $_POST['status'];
$sessions = $_POST['sessions'];

$conn->query("INSERT INTO `tb_users` (`username`, `password`, `status`, `sessions`) VALUES ('$username', '$password', '$status', '$sessions')");
