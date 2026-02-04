-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.24-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table erp.business_unit
CREATE TABLE IF NOT EXISTS `business_unit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_unit_name` varchar(100) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `business_unit_business_unit_name_idx` (`business_unit_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table erp.business_unit: ~0 rows (approximately)
DELETE FROM `business_unit`;
INSERT INTO `business_unit` (`id`, `business_unit_name`, `status`, `created_at`, `updated_at`) VALUES
	(1, 'Payments', 1, '2026-02-01 19:03:41', '2026-02-01 19:03:41'),
	(2, 'Reports', 1, '2026-02-04 00:56:09', '2026-02-04 00:56:09'),
	(3, 'Heavy Machinary', 1, '2026-02-04 00:57:28', '2026-02-04 00:57:28');

-- Dumping structure for table erp.categories
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) DEFAULT NULL,
  `STATUS` tinyint(4) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `categories_category_name_idx` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table erp.categories: ~2 rows (approximately)
DELETE FROM `categories`;
INSERT INTO `categories` (`id`, `category_name`, `STATUS`, `created_at`, `updated_at`) VALUES
	(1, 'Processing Issue', 1, '2026-02-01 19:05:40', '2026-02-01 19:05:40'),
	(2, 'Data Issue', 1, '2026-02-01 19:06:11', '2026-02-01 19:06:11'),
	(3, 'Report Issue', 1, '2026-02-04 00:55:49', '2026-02-04 00:55:49');

-- Dumping structure for table erp.environments
CREATE TABLE IF NOT EXISTS `environments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `env_name` varchar(100) DEFAULT NULL,
  `STATUS` tinyint(4) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `environments_env_name_idx` (`env_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table erp.environments: ~0 rows (approximately)
DELETE FROM `environments`;
INSERT INTO `environments` (`id`, `env_name`, `STATUS`, `created_at`, `updated_at`) VALUES
	(1, 'Production', 1, '2026-02-01 19:06:11', '2026-02-01 19:06:11'),
	(2, 'UAT', 1, '2026-02-04 00:57:39', '2026-02-04 00:57:39'),
	(3, 'Staging', 1, '2026-02-04 00:57:45', '2026-02-04 00:57:45');

-- Dumping structure for table erp.erp_module
CREATE TABLE IF NOT EXISTS `erp_module` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `erp_name` varchar(100) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `erp_module_erp_name_idx` (`erp_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table erp.erp_module: ~0 rows (approximately)
DELETE FROM `erp_module`;
INSERT INTO `erp_module` (`id`, `erp_name`, `status`, `created_at`, `updated_at`) VALUES
	(1, 'Payroll', 1, '2026-02-01 19:06:11', '2026-02-01 19:06:11'),
	(2, 'Attendance', 1, '2026-02-04 00:57:59', '2026-02-04 00:57:59'),
	(3, 'Time Management', 1, '2026-02-04 00:58:06', '2026-02-04 00:58:06');

-- Dumping structure for table erp.incidents
CREATE TABLE IF NOT EXISTS `incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `description` text NOT NULL,
  `erp_module_id` int(11) DEFAULT NULL,
  `env_id` int(11) DEFAULT NULL,
  `business_unit_id` int(11) DEFAULT NULL,
  `severity` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `erp_module_id` (`erp_module_id`),
  KEY `business_unit_id` (`business_unit_id`),
  KEY `category_id` (`category_id`),
  KEY `env_id` (`env_id`),
  CONSTRAINT `incidents_ibfk_1` FOREIGN KEY (`erp_module_id`) REFERENCES `erp_module` (`id`),
  CONSTRAINT `incidents_ibfk_2` FOREIGN KEY (`business_unit_id`) REFERENCES `business_unit` (`id`),
  CONSTRAINT `incidents_ibfk_3` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `incidents_ibfk_4` FOREIGN KEY (`env_id`) REFERENCES `environments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table erp.incidents: ~8 rows (approximately)
DELETE FROM `incidents`;
INSERT INTO `incidents` (`id`, `title`, `client_id`, `description`, `erp_module_id`, `env_id`, `business_unit_id`, `severity`, `category_id`, `status`, `created_at`, `updated_at`) VALUES
	(1, 'payment ticket', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-01 14:40:47', '2026-02-01 16:50:46'),
	(2, 'testing ticket', 10, ' service is up', 1, 1, 1, 3, 1, 1, '2026-02-01 16:11:59', '2026-02-01 16:11:59'),
	(3, 'testing ticket', 10, ' service is up', 1, 1, 1, 3, 1, 1, '2026-02-01 16:12:05', '2026-02-01 16:12:05'),
	(4, 'testing ticket', 10, ' service is up', 1, 1, 1, 3, 1, 1, '2026-02-01 16:12:07', '2026-02-01 16:12:07'),
	(5, 'testing ticket', 10, ' service is up', 1, 1, 1, 3, 1, 1, '2026-02-01 16:12:08', '2026-02-01 16:12:08'),
	(6, 'testing ticket', 10, ' service is down', 1, 1, 1, 1, 1, 1, '2026-02-01 16:12:37', '2026-02-01 16:12:37'),
	(7, 'testing ticket', 10, ' client is facing issue', 1, 1, 1, 1, 1, 1, '2026-02-01 16:12:47', '2026-02-01 16:12:47'),
	(8, 'payment ticket', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-01 16:43:30', '2026-02-01 16:43:30'),
	(10, 'payment ticket', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-02 19:03:30', '2026-02-02 19:03:30'),
	(11, 'payment ticket', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-02 19:03:31', '2026-02-02 19:03:31'),
	(12, 'payment ticket', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-02 19:03:32', '2026-02-02 19:03:32'),
	(19, 'issue 1', 10, 'one', 1, 1, 1, 3, 1, 1, '2026-02-03 20:06:36', '2026-02-03 20:06:36'),
	(20, 'issue 2', 10, 'issue 2', 2, 2, 2, 2, 2, 1, '2026-02-03 20:07:45', '2026-02-03 20:07:45'),
	(21, 'payment ticket_1', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-03 20:35:39', '2026-02-03 20:35:39'),
	(22, 'payment ticket_1', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-03 20:37:34', '2026-02-03 20:37:34'),
	(23, 'payment ticket_1', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-03 20:38:07', '2026-02-03 20:38:07'),
	(24, 'payment ticket_1', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-03 20:39:10', '2026-02-03 20:39:10'),
	(25, 'payment ticket_1', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-03 20:39:33', '2026-02-03 20:39:33'),
	(26, 'payment ticket_1', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-03 20:40:37', '2026-02-03 20:40:37'),
	(27, 'payment ticket_1', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-03 20:40:57', '2026-02-03 20:40:57'),
	(28, 'payment ticket_1', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-03 20:43:32', '2026-02-03 20:43:32'),
	(29, 'payment ticket_1', 10, ' payment is facing issue multiple times', 1, 1, 1, 1, 1, 1, '2026-02-03 20:43:55', '2026-02-03 20:43:55');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
