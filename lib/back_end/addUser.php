<?php
include 'conn.php';

$username = $_POST['username'];
$password = $_POST['password'];

$conn->query("INSERT INTO `tb_users` (`username`, `password`, `status`, `sessions`, `account_status`) VALUES ('$username', '$password', 'logout', '0', 'enable')");
