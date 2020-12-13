-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 13, 2020 at 10:40 AM
-- Server version: 10.4.13-MariaDB
-- PHP Version: 7.4.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `id14472488_db_um`
--

-- --------------------------------------------------------

--
-- Table structure for table `log_message`
--

CREATE TABLE `log_message` (
  `time` datetime NOT NULL,
  `message_id` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `status` enum('unreaded','readed') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `log_message`
--

INSERT INTO `log_message` (`time`, `message_id`, `message`, `status`) VALUES
('2020-12-13 16:37:56', 'jayatotri', 'Hello tri', 'readed'),
('2020-12-13 16:38:34', 'tritojaya', 'Hi, what\'s up bro?', 'unreaded');

-- --------------------------------------------------------

--
-- Table structure for table `tb_admin`
--

CREATE TABLE `tb_admin` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `sessions` int(11) NOT NULL,
  `reset_code` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_admin`
--

INSERT INTO `tb_admin` (`id`, `username`, `password`, `sessions`, `reset_code`) VALUES
(1, 'admin', 'admin', 0, 'reset');

-- --------------------------------------------------------

--
-- Table structure for table `tb_messages`
--

CREATE TABLE `tb_messages` (
  `id` varchar(50) NOT NULL,
  `sender` varchar(20) NOT NULL,
  `receiver` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_messages`
--

INSERT INTO `tb_messages` (`id`, `sender`, `receiver`) VALUES
('jayatotri', 'jaya', 'tri'),
('tritojaya', 'tri', 'jaya');

-- --------------------------------------------------------

--
-- Table structure for table `tb_users`
--

CREATE TABLE `tb_users` (
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `status` varchar(6) NOT NULL,
  `sessions` int(11) NOT NULL,
  `account_status` varchar(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_users`
--

INSERT INTO `tb_users` (`username`, `password`, `status`, `sessions`, `account_status`) VALUES
('jaya', 'qwertyui', 'logout', 0, 'enable'),
('tri', '12345678', 'login', 1, 'enable');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `log_message`
--
ALTER TABLE `log_message`
  ADD PRIMARY KEY (`time`),
  ADD KEY `fk_message_id` (`message_id`);

--
-- Indexes for table `tb_admin`
--
ALTER TABLE `tb_admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_messages`
--
ALTER TABLE `tb_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sender` (`sender`),
  ADD KEY `fk_reciver` (`receiver`);

--
-- Indexes for table `tb_users`
--
ALTER TABLE `tb_users`
  ADD PRIMARY KEY (`username`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_admin`
--
ALTER TABLE `tb_admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `log_message`
--
ALTER TABLE `log_message`
  ADD CONSTRAINT `fk_message_id` FOREIGN KEY (`message_id`) REFERENCES `tb_messages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tb_messages`
--
ALTER TABLE `tb_messages`
  ADD CONSTRAINT `fk_reciver` FOREIGN KEY (`receiver`) REFERENCES `tb_users` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sender` FOREIGN KEY (`sender`) REFERENCES `tb_users` (`username`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
