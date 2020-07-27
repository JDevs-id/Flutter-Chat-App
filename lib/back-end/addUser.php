<?php
include 'conn.php';

$username = $_POST['username'];
$password = $_POST['password'];
$status = $_POST['status'];

$conn->query("INSERT INTO `tb_user` (`username`, `password`, `status`) VALUES ('$username', '$password', '$status')");
