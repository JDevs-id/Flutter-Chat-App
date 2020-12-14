<?php
include 'conn.php';

$message_id = $_POST['message_id'];
$message_id_invert = $_POST['message_id_invert'];
$sender = $_POST['sender'];
$receiver = $_POST['receiver'];
$time = $_POST['time'];
$message = $_POST['message'];

$qMessageIDCheck = $conn->query("SELECT * FROM `tb_messages` WHERE `message_id`='$message_id'");
$qMessageIDInvertCheck = $conn->query("SELECT * FROM `tb_messages` WHERE `message_id`='$message_id_invert'");

if ($qMessageIDCheck->num_rows = 0) {
    $conn->query("INSERT INTO `tb_messages` (`message_id`, `sender`, `receiver`) VALUES ('$message_id', '$sender', '$receiver')");
} elseif ($qMessageIDInvertCheck->num_rows = 0) {
    $conn->query("INSERT INTO `tb_messages` (`message_id`, `sender`, `receiver`) VALUES ('$message_id_invert', '$receiver', '$sender')");
}

$conn->query("INSERT INTO `log_messages` (`time`, `message_id`, `message`, `status`) VALUES ('$time', '$message_id', '$message', 'unreaded')");
