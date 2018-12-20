-- phpMyAdmin SQL Dump
-- version 4.6.6
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Dec 18, 2018 at 05:01 PM
-- Server version: 5.6.35
-- PHP Version: 7.1.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `zanichelli`
--
CREATE DATABASE IF NOT EXISTS `zanichelli` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `zanichelli`;

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
CREATE TABLE IF NOT EXISTS `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) DEFAULT NULL,
  `vote` int(11)  DEFAULT NULL,
  `description` text,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_single_title_per_user` (`user_id`,`title`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

--
-- Truncate table before insert `books`
--

TRUNCATE TABLE `books`;
--
-- Dumping data for table `books`
--

INSERT INTO `books` (`id`, `title`, `author`, `vote`,`description`, `user_id`) VALUES
(14, 'Moby dick', 'Author 1', 3,  'una storia di balene', 3),
(15, 'Casa nella prateria', 3, 'Author 2', 'this is a very long description', 3);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `surname` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Truncate table before insert `users`
--

TRUNCATE TABLE `users`;
--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `name`, `surname`, `password`) VALUES
(3, 'orlandil@gmail.com', 'Lorenzo', 'Orlandi', 'password');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `fk_book_to_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
