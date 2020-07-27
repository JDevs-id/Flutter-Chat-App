<?php
include 'conn.php';

$username = $_POST['username'];
$password = $_POST['password'];

$conn->query("INSERT INTO `tb_user` (`username`, `password`) VALUES ('$username', '$password')");
