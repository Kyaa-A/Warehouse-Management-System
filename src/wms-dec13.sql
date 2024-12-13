-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 13, 2024 at 04:16 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wms`
--

-- --------------------------------------------------------

--
-- Table structure for table `accountdetails`
--

CREATE TABLE `accountdetails` (
  `user_id` int(11) NOT NULL,
  `accUsername` varchar(251) NOT NULL,
  `accPassword` varchar(251) NOT NULL,
  `role` int(11) NOT NULL DEFAULT 1,
  `email` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accountdetails`
--

INSERT INTO `accountdetails` (`user_id`, `accUsername`, `accPassword`, `role`, `email`, `created_at`) VALUES
(1, 'Admin', '123', 2, 'admin@warehouse.com', '2024-12-03 17:00:00'),
(2, 'Kyaa', '123', 1, 'kyaa@warehouse.com', '2024-12-03 17:00:00'),
(6, 'merlin', '123', 1, NULL, '2024-12-11 06:05:33'),
(8, 'merllak', '45', 1, 'merlak@gmail.com', '2024-12-11 08:21:42'),
(9, 'hehe', '123', 1, 'hehe@gmail.com', '2024-12-11 08:36:06'),
(10, 'Brandon', '123', 1, 'brandon@gmail.com', '2024-12-11 09:06:28'),
(11, 'Labu', '123', 1, 'labulabu@gmail.com', '2024-12-12 14:47:11'),
(12, 'Zenitsu', '123', 1, 'zenitsu@gmail.com', '2024-12-12 14:50:50'),
(13, 'Hiresh', '123', 1, 'hiresh@gmail.com', '2024-12-13 02:42:12');

-- --------------------------------------------------------

--
-- Table structure for table `carriers`
--

CREATE TABLE `carriers` (
  `carrier_id` int(11) NOT NULL,
  `carrier_name` varchar(255) NOT NULL,
  `contact_info` text DEFAULT NULL,
  `service_level` enum('EXPRESS','STANDARD','ECONOMY') NOT NULL,
  `average_work_time` varchar(20) DEFAULT '24-48 hours',
  `delivery_time` varchar(20) DEFAULT '3-5 days',
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `carriers`
--

INSERT INTO `carriers` (`carrier_id`, `carrier_name`, `contact_info`, `service_level`, `average_work_time`, `delivery_time`, `active`) VALUES
(1, 'J&T Express', 'contact@jtexpress.ph', 'EXPRESS', '12-24 hours', '1-2 days', 1),
(2, 'LBC Express', 'info@lbcexpress.com', 'EXPRESS', '12-24 hours', '1-2 days', 1),
(3, 'Ninja Van', 'support@ninjavan.ph', 'STANDARD', '24-48 hours', '3-5 days', 1),
(4, '2GO', 'info@2go.com.ph', 'STANDARD', '24-48 hours', '3-5 days', 1),
(5, 'Budget Carriers', 'support@budget.com', 'ECONOMY', '48-72 hours', '5-7 days', 0),
(6, 'Premium Delivery', 'help@premium.com', 'EXPRESS', '12-24 hours', '1-2 days', 1),
(7, 'Quick Ship Co.', 'service@quickship.com', 'EXPRESS', '12-24 hours', '1-2 days', 1),
(8, 'Safe Cargo Ltd.', 'info@safecargo.com', 'STANDARD', '24-48 hours', '3-5 days', 0),
(9, 'Economy Express', 'contact@economyexpress.com', 'ECONOMY', '48-72 hours', '5-7 days', 1),
(10, 'Global Logistics', 'support@global.com', 'STANDARD', '24-48 hours', '3-5 days', 1),
(11, 'Rapid Transit', 'info@rapid.com', 'EXPRESS', '12-24 hours', '1-2 days', 0),
(12, 'Value Shipping', 'contact@value.com', 'ECONOMY', '48-72 hours', '5-7 days', 1),
(13, 'FastTrack Logistics', 'contact@fasttrack.com', 'EXPRESS', '12-24 hours', '1-2 days', 0),
(14, 'EconoShip', 'support@econoship.com', 'ECONOMY', '48-72 hours', '5-7 days', 1),
(15, 'ReliableFreight', 'info@reliablefreight.com', 'STANDARD', '24-48 hours', '3-5 days', 1),
(16, 'SpeedyDelivery', 'customercare@speedydelivery.com', 'EXPRESS', '12-24 hours', '1-2 days', 1),
(17, 'BudgetCarriers', 'service@budgetcarriers.com', 'ECONOMY', '48-72 hours', '5-7 days', 0);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `customer_name`, `email`, `phone`, `address`, `created_at`, `user_id`) VALUES
(1, 'John Smith', 'johnsmith89@gmail.com', '09783918362', 'Block 4 Lot 12, Green Valley Subdivision, Davao City, 8000', '2024-02-14 17:30:00', NULL),
(2, 'Jane Smith', 'janesmith@yahoo.com', '09276543210', 'Unit 305 Sunshine Tower, Roxas Avenue, Davao City, 8000', '2024-03-21 22:45:00', NULL),
(3, 'Robert Johnson', 'robertjohnson@outlook.com', '09376511710', '123 Mango Street, Ma-a, Davao City, 8000', '2024-04-09 19:20:00', NULL),
(4, 'Sarah Williams', 'sarahwilliams24@gmail.com', '09551456884', 'Phase 1, Block 8, Lot 15, Catalunan Grande, Davao City, 8000', '2024-05-05 00:30:00', NULL),
(5, 'Michael Brown', 'michaelbrown@gmail.com', '09074687069', '789 JP Laurel Avenue, Bajada, Davao City, 8000', '2024-06-17 18:15:00', NULL),
(6, 'Emily Davis', 'emilydavis92@yahoo.com', '09305696949', 'Door 3, JM Building, CM Recto Street, Davao City, 8000', '2024-06-30 21:45:00', NULL),
(7, 'David Miller', 'davidmiller@outlook.com', '09285733452', 'Unit 1204 Apo View Hotel, Camus Street, Davao City, 8000', '2024-08-11 17:00:00', NULL),
(8, 'Lisa Wilson', 'lisawilson88@gmail.com', '09740205540', 'Block 15 Lot 7, NHA Buhangin, Davao City, 8000', '2024-09-24 23:20:00', NULL),
(9, 'James Anderson', 'jamesanderson@yahoo.com', '09135886638', '567 Quimpo Boulevard, Ecoland, Davao City, 8000', '2024-10-07 19:30:00', NULL),
(10, 'Jennifer Taylor', 'jennifertaylor@gmail.com', '09327065652', 'Unit 506 Marco Polo Hotel, CM Recto Street, Davao City, 8000', '2024-10-29 22:10:00', NULL),
(11, 'William Moore', 'williammoore77@outlook.com', '09043614343', '234 Ponciano Street, Poblacion District, Davao City, 8000', '2024-11-14 18:45:00', NULL),
(12, 'Emma Thomas', 'emmathomas@yahoo.com', '09525764975', 'Door 2, Ground Floor, Victoria Plaza, JP Laurel Ave, Davao City, 8000', '2024-12-01 00:00:00', NULL),
(13, 'merllak', 'merlak@gmail.com', '09783615372', 'Valencia City Bukidnon', '2024-12-11 08:21:42', 8),
(14, 'hehe', 'hehe@gmail.com', '09738193746', 'Lapu-Lapu Street, Digos City', '2024-12-11 08:36:06', 9),
(15, 'Brandon', 'brandon@gmail.com', '09892716483', 'Park, Digos City', '2024-12-11 09:06:28', 10),
(16, 'Labu', 'labulabu@gmail.com', '09682713512', 'Luna Street, Digos City', '2024-12-12 14:47:11', 11),
(17, 'Zenitsu', 'zenitsu@gmail.com', '09728467132', 'Rizal Park, Digos City', '2024-12-12 14:50:50', 12),
(18, 'Hiresh', 'hiresh@gmail.com', '09672813423', 'Mabini Extension, Digos City', '2024-12-13 02:42:12', 13);

-- --------------------------------------------------------

--
-- Table structure for table `customer_notifications`
--

CREATE TABLE `customer_notifications` (
  `notification_id` int(11) NOT NULL,
  `order_id` varchar(20) NOT NULL,
  `notification_type` enum('ORDER_CONFIRMATION','SHIPPING_UPDATE','DELIVERY_CONFIRMATION') NOT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('SENT','FAILED') NOT NULL,
  `message` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications_history`
--

CREATE TABLE `notifications_history` (
  `notification_id` int(11) NOT NULL,
  `order_id` varchar(20) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `status` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `products` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications_history`
--

INSERT INTO `notifications_history` (`notification_id`, `order_id`, `customer_id`, `status`, `message`, `products`, `created_at`) VALUES
(1, 'ORD-037', 18, 'VERIFIED', 'Your order has been verified and approved!', 'CPU Cooler (1)', '2024-12-13 02:43:52'),
(2, 'ORD-036', 18, 'VERIFIED', 'Your order has been verified and approved!', 'Gaming Mouse Pad (3), Wireless Keyboard (1)', '2024-12-13 02:44:13'),
(3, 'ORD-036', 18, 'PACKED', 'Your order has been packed and is ready for shipping!', 'Gaming Mouse Pad (3), Wireless Keyboard (1)', '2024-12-13 02:44:39'),
(4, 'ORD-035', 18, 'VERIFIED', 'Your order has been verified and approved!', 'Mechanical Keyboard (1)', '2024-12-13 02:44:56'),
(5, 'ORD-035', 18, 'PACKED', 'Your order has been packed and is ready for shipping!', 'Mechanical Keyboard (1)', '2024-12-13 02:45:01'),
(6, 'ORD-035', 18, 'SHIPPED', 'Your order is on the way!', 'Mechanical Keyboard (1)', '2024-12-13 02:45:14'),
(7, 'ORD-040', 18, 'VERIFIED', 'Your order has been verified and approved!', 'SSD Drive (1)', '2024-12-13 03:02:27'),
(8, 'ORD-039', 18, 'VERIFIED', 'Your order has been verified and approved!', 'Power Supply (1)', '2024-12-13 03:02:30'),
(9, 'ORD-038', 18, 'VERIFIED', 'Your order has been verified and approved!', 'CPU Cooler (5)', '2024-12-13 03:02:33'),
(10, 'ORD-035', 18, 'DELIVERED', 'Your order has been delivered!', 'Mechanical Keyboard (1)', '2024-12-13 03:02:37'),
(11, 'ORD-038', 18, 'PACKED', 'Your order has been packed and is ready for shipping!', 'CPU Cooler (5)', '2024-12-13 03:02:44'),
(12, 'ORD-038', 18, 'SHIPPED', 'Your order is on the way!', 'CPU Cooler (5)', '2024-12-13 03:02:53'),
(13, 'ORD-038', 18, 'DELIVERED', 'Your order has been delivered!', 'CPU Cooler (5)', '2024-12-13 03:06:52'),
(14, 'ORD-036', 18, 'SHIPPED', 'Your order is on the way!', 'Gaming Mouse Pad (3), Wireless Keyboard (1)', '2024-12-13 03:08:12'),
(15, 'ORD-037', 18, 'PACKED', 'Your order has been packed and is ready for shipping!', 'CPU Cooler (1)', '2024-12-13 03:08:27'),
(16, 'ORD-039', 18, 'PACKED', 'Your order has been packed and is ready for shipping!', 'Power Supply (1)', '2024-12-13 03:08:42'),
(17, 'ORD-039', 18, 'SHIPPED', 'Your order is on the way!', 'Power Supply (1)', '2024-12-13 03:08:50');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` varchar(20) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `status` enum('PENDING','VERIFIED','PACKED','SHIPPED','DELIVERED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `notification_status` enum('PENDING','SENT','FAILED') DEFAULT 'PENDING',
  `order_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `tracking_number` varchar(50) DEFAULT NULL,
  `carrier_id` int(11) DEFAULT NULL,
  `shipping_dock` varchar(50) DEFAULT NULL,
  `dispatch_time` timestamp NULL DEFAULT NULL,
  `priority` enum('HIGH','MEDIUM','LOW') NOT NULL DEFAULT 'MEDIUM',
  `label` enum('Fragile Items','Do Not Stack','Keep Dry','Temperature Sensitive','Hazardous Material','Heavy Package') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `customer_id`, `status`, `notification_status`, `order_date`, `last_updated`, `tracking_number`, `carrier_id`, `shipping_dock`, `dispatch_time`, `priority`, `label`) VALUES
('ORD-001', 1, 'SHIPPED', 'PENDING', '2024-12-03 17:00:00', '2024-12-07 05:00:35', 'TRK15123123', 1, NULL, NULL, 'HIGH', 'Fragile Items'),
('ORD-002', 2, 'SHIPPED', 'PENDING', '2024-12-03 17:00:00', '2024-12-07 05:00:35', 'TRK15123124', 2, NULL, NULL, 'MEDIUM', 'Heavy Package'),
('ORD-003', 3, 'SHIPPED', 'PENDING', '2024-12-03 09:00:00', '2024-12-11 05:02:31', 'TRK1512312', 8, NULL, NULL, 'MEDIUM', 'Temperature Sensitive'),
('ORD-004', 4, 'DELIVERED', 'PENDING', '2024-12-03 09:00:00', '2024-12-07 05:00:35', 'TRK15123136', 4, NULL, NULL, 'HIGH', ''),
('ORD-005', 5, 'VERIFIED', 'PENDING', '2024-12-03 09:00:00', '2024-12-07 05:00:35', NULL, NULL, NULL, NULL, 'LOW', ''),
('ORD-006', 6, 'SHIPPED', 'PENDING', '2024-12-03 09:00:00', '2024-12-04 00:48:00', 'TRK15123126', 6, NULL, NULL, 'MEDIUM', ''),
('ORD-007', 7, 'DELIVERED', 'PENDING', '2024-12-03 09:00:00', '2024-12-07 16:31:37', NULL, 7, NULL, NULL, 'HIGH', ''),
('ORD-008', 8, 'SHIPPED', 'PENDING', '2024-12-03 09:00:00', '2024-12-11 05:02:42', 'TRK15123138', 16, NULL, NULL, 'LOW', ''),
('ORD-009', 9, 'SHIPPED', 'PENDING', '2024-12-03 09:00:00', '2024-12-07 05:00:35', 'TRK15123127', 9, NULL, NULL, 'MEDIUM', 'Fragile Items'),
('ORD-010', 10, 'SHIPPED', 'PENDING', '2024-12-03 09:00:00', '2024-12-07 05:00:35', 'TRK15123128', 10, NULL, NULL, 'HIGH', 'Heavy Package'),
('ORD-011', 1, 'VERIFIED', 'PENDING', '2024-12-03 09:00:00', '2024-12-07 16:00:19', NULL, NULL, NULL, NULL, 'LOW', 'Temperature Sensitive'),
('ORD-012', 2, 'PACKED', 'PENDING', '2024-12-03 09:00:00', '2024-12-11 05:04:02', 'WH-241211130402-004', NULL, 'Dock B', NULL, 'HIGH', 'Fragile Items'),
('ORD-013', 3, 'PACKED', 'PENDING', '2024-12-01 18:30:00', '2024-12-11 04:45:09', 'WH-241211124509-001', NULL, 'Dock A', NULL, 'HIGH', 'Fragile Items'),
('ORD-014', 6, 'DELIVERED', 'PENDING', '2024-11-30 22:00:00', '2024-12-07 05:00:35', 'TRK15123129', 6, NULL, NULL, 'HIGH', 'Temperature Sensitive'),
('ORD-015', 5, 'SHIPPED', 'PENDING', '2024-11-29 16:15:00', '2024-12-07 05:00:35', 'TRK15123130', 2, NULL, NULL, 'MEDIUM', ''),
('ORD-016', 5, 'PENDING', 'PENDING', '2024-11-29 16:15:00', '2024-12-07 05:00:35', NULL, NULL, NULL, NULL, '', ''),
('ORD-017', 5, 'VERIFIED', 'PENDING', '2024-11-29 16:15:00', '2024-12-12 14:54:13', NULL, NULL, NULL, NULL, '', ''),
('ORD-018', 5, 'PENDING', 'PENDING', '2024-11-29 16:15:00', '2024-12-07 05:00:35', NULL, NULL, NULL, NULL, '', ''),
('ORD-019', 9, 'PENDING', 'PENDING', '2024-12-11 16:51:08', '2024-12-11 16:51:08', NULL, NULL, NULL, NULL, 'MEDIUM', NULL),
('ORD-020', 14, 'VERIFIED', 'PENDING', '2024-12-11 16:56:45', '2024-12-12 15:37:36', NULL, NULL, NULL, NULL, 'MEDIUM', NULL),
('ORD-021', 13, 'PENDING', 'PENDING', '2024-12-11 16:59:01', '2024-12-11 16:59:01', NULL, NULL, NULL, NULL, 'MEDIUM', NULL),
('ORD-022', 13, 'PENDING', 'PENDING', '2024-12-11 16:59:08', '2024-12-11 16:59:08', NULL, NULL, NULL, NULL, 'MEDIUM', NULL),
('ORD-023', 13, 'VERIFIED', 'PENDING', '2024-12-11 16:59:25', '2024-12-11 17:02:47', NULL, NULL, NULL, NULL, 'MEDIUM', NULL),
('ORD-024', 16, 'PENDING', 'PENDING', '2024-12-12 14:48:12', '2024-12-12 14:48:12', NULL, NULL, NULL, NULL, 'MEDIUM', NULL),
('ORD-025', 16, 'VERIFIED', 'PENDING', '2024-12-12 14:49:52', '2024-12-12 14:54:11', NULL, NULL, NULL, NULL, 'MEDIUM', NULL),
('ORD-026', 17, 'DELIVERED', 'PENDING', '2024-12-12 14:51:24', '2024-12-13 02:38:22', 'WH-241213000726-002', 4, 'Dock A', NULL, 'HIGH', 'Fragile Items'),
('ORD-027', 14, 'DELIVERED', 'PENDING', '2024-12-12 15:02:14', '2024-12-12 15:03:54', 'WH-241212230342-001', 17, 'Dock A', NULL, 'HIGH', 'Fragile Items'),
('ORD-028', 17, 'PACKED', 'PENDING', '2024-12-12 15:04:57', '2024-12-12 16:06:35', 'WH-241213000635-001', NULL, 'Dock F', NULL, 'HIGH', 'Fragile Items'),
('ORD-029', 17, 'SHIPPED', 'PENDING', '2024-12-12 15:05:13', '2024-12-12 16:16:18', 'WH-241213001057-003', 5, 'Dock H', NULL, 'HIGH', 'Fragile Items'),
('ORD-030', 16, 'PENDING', 'PENDING', '2024-12-12 15:08:04', '2024-12-12 15:08:04', NULL, NULL, NULL, NULL, 'MEDIUM', 'Fragile Items'),
('ORD-031', 17, 'VERIFIED', 'PENDING', '2024-12-12 16:22:03', '2024-12-12 16:22:21', NULL, NULL, NULL, NULL, 'MEDIUM', 'Temperature Sensitive'),
('ORD-032', 17, 'PENDING', 'PENDING', '2024-12-13 01:03:12', '2024-12-13 01:03:12', NULL, NULL, NULL, NULL, 'MEDIUM', 'Temperature Sensitive'),
('ORD-033', 14, 'SHIPPED', 'PENDING', '2024-12-13 01:07:00', '2024-12-13 01:08:18', 'WH-241213090810-005', 9, 'Dock B', NULL, 'HIGH', 'Fragile Items'),
('ORD-034', 14, 'DELIVERED', 'PENDING', '2024-12-13 01:07:16', '2024-12-13 01:08:01', 'WH-241213090749-004', 5, 'Dock D', NULL, 'LOW', 'Keep Dry'),
('ORD-035', 18, 'DELIVERED', 'PENDING', '2024-12-13 02:42:57', '2024-12-13 03:02:37', 'WH-241213104501-007', 8, 'Dock E', NULL, 'HIGH', 'Fragile Items'),
('ORD-036', 18, 'SHIPPED', 'PENDING', '2024-12-13 02:43:19', '2024-12-13 03:08:12', 'WH-241213104439-006', 17, 'Dock A', NULL, 'MEDIUM', 'Temperature Sensitive'),
('ORD-037', 18, 'PACKED', 'PENDING', '2024-12-13 02:43:28', '2024-12-13 03:08:27', 'WH-241213110827-009', NULL, 'Dock A', NULL, 'HIGH', 'Fragile Items'),
('ORD-038', 18, 'DELIVERED', 'PENDING', '2024-12-13 02:59:30', '2024-12-13 03:06:52', 'WH-241213110244-008', 11, 'Dock G', NULL, 'HIGH', 'Fragile Items'),
('ORD-039', 18, 'SHIPPED', 'PENDING', '2024-12-13 02:59:41', '2024-12-13 03:08:50', 'WH-241213110842-010', 8, 'Dock E', NULL, 'HIGH', 'Keep Dry'),
('ORD-040', 18, 'VERIFIED', 'PENDING', '2024-12-13 03:02:12', '2024-12-13 03:02:27', NULL, NULL, NULL, NULL, 'MEDIUM', NULL);

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `order_status_notification` AFTER UPDATE ON `orders` FOR EACH ROW BEGIN
    DECLARE product_list TEXT;
    
    -- Get the product list for this order
    SELECT GROUP_CONCAT(CONCAT(p.product_name, ' (', oi.quantity, ')') SEPARATOR ', ')
    INTO product_list
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    WHERE oi.order_id = NEW.order_id;

    -- Only create notification if status has changed
    IF NEW.status != OLD.status THEN
        INSERT INTO notifications_history (order_id, customer_id, status, message, products)
        VALUES (
            NEW.order_id,
            NEW.customer_id,
            NEW.status,
            CASE NEW.status
                WHEN 'VERIFIED' THEN 'Your order has been verified and approved!'
                WHEN 'PACKED' THEN 'Your order has been packed and is ready for shipping!'
                WHEN 'SHIPPED' THEN 'Your order is on the way!'
                WHEN 'DELIVERED' THEN 'Your order has been delivered!'
                ELSE CONCAT('Order status updated to: ', NEW.status)
            END,
            product_list
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `item_id` int(11) NOT NULL,
  `order_id` varchar(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `location` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`item_id`, `order_id`, `product_id`, `quantity`, `location`) VALUES
(1, 'ORD-001', 4, 2, 'A-101'),
(2, 'ORD-002', 6, 1, 'A-102'),
(3, 'ORD-003', 8, 1, 'A-103'),
(4, 'ORD-004', 5, 2, 'A-104'),
(5, 'ORD-005', 9, 2, 'A-105'),
(6, 'ORD-006', 7, 3, 'A-106'),
(7, 'ORD-007', 10, 4, 'A-107'),
(8, 'ORD-008', 12, 1, 'A-108'),
(9, 'ORD-009', 3, 1, 'A-109'),
(10, 'ORD-010', 15, 1, 'A-110'),
(11, 'ORD-011', 14, 2, 'A-111'),
(12, 'ORD-012', 16, 1, 'A-112'),
(13, 'ORD-013', 17, 1, 'A-113'),
(14, 'ORD-014', 18, 1, 'A-114'),
(15, 'ORD-015', 20, 2, 'A-115'),
(16, 'ORD-016', 12, 3, 'A-113'),
(17, 'ORD-017', 3, 1, 'A-103'),
(18, 'ORD-018', 7, 2, 'A-109'),
(47, 'ORD-019', 5, 1, NULL),
(48, 'ORD-019', 4, 1, NULL),
(51, 'ORD-020', 4, 2, NULL),
(54, 'ORD-021', 12, 1, NULL),
(55, 'ORD-021', 9, 1, NULL),
(56, 'ORD-022', 7, 1, NULL),
(57, 'ORD-023', 10, 2, NULL),
(58, 'ORD-023', 9, 1, NULL),
(61, 'ORD-024', 4, 1, NULL),
(65, 'ORD-025', 7, 2, NULL),
(70, 'ORD-026', 7, 1, NULL),
(78, 'ORD-028', 3, 2, NULL),
(79, 'ORD-029', 18, 2, NULL),
(80, 'ORD-030', 3, 2, NULL),
(81, 'ORD-030', 8, 1, NULL),
(82, 'ORD-031', 14, 1, NULL),
(83, 'ORD-031', 15, 1, NULL),
(84, 'ORD-031', 16, 1, NULL),
(85, 'ORD-032', 8, 1, NULL),
(86, 'ORD-033', 5, 1, NULL),
(87, 'ORD-033', 8, 1, NULL),
(88, 'ORD-034', 4, 1, NULL),
(89, 'ORD-035', 4, 1, NULL),
(90, 'ORD-036', 10, 3, NULL),
(91, 'ORD-036', 12, 1, NULL),
(92, 'ORD-037', 14, 1, NULL),
(93, 'ORD-038', 14, 5, NULL),
(94, 'ORD-039', 18, 1, NULL),
(95, 'ORD-040', 9, 1, NULL);

--
-- Triggers `order_items`
--
DELIMITER $$
CREATE TRIGGER `auto_assign_label` AFTER INSERT ON `order_items` FOR EACH ROW BEGIN
    DECLARE product_category VARCHAR(50);
    DECLARE product_weight DECIMAL(10,2);
    DECLARE new_label VARCHAR(50);
    
    -- Get product information
    SELECT category, weight INTO product_category, product_weight
    FROM products
    WHERE product_id = NEW.product_id;
    
    -- Determine appropriate label
    IF product_category = 'Electronics' THEN
        SET new_label = 'Fragile Items';
    ELSEIF product_weight * NEW.quantity > 10 THEN
        SET new_label = 'Heavy Package';
    ELSEIF product_category = 'Components' THEN
        SET new_label = 'Temperature Sensitive';
    END IF;
    
    -- Update order label if not already set
    IF new_label IS NOT NULL THEN
        UPDATE orders
        SET label = COALESCE(label, new_label)
        WHERE order_id = NEW.order_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `packing_details`
--

CREATE TABLE `packing_details` (
  `packing_id` int(11) NOT NULL,
  `order_id` varchar(20) NOT NULL,
  `box_size` varchar(50) DEFAULT NULL,
  `packing_materials` text DEFAULT NULL,
  `packed_by` int(11) DEFAULT NULL,
  `packed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `stock` int(11) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `weight` decimal(10,2) DEFAULT 0.00,
  `category` enum('Electronics','Accessories','Components','Peripherals','Storage','Networking') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `image_data` longblob DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `price`, `stock`, `description`, `weight`, `category`, `created_at`, `image_data`, `active`) VALUES
(3, '4K Monitor', 15999.00, 11, 'Ultra HD Display Monitor', 5.00, 'Electronics', '2024-01-08 08:00:00', NULL, 1),
(4, 'Mechanical Keyboard', 2999.00, 24, 'RGB Gaming Keyboard', 1.20, 'Peripherals', '2024-01-22 08:00:00', NULL, 1),
(5, 'Gaming Headset', 1999.00, 23, 'Wireless Gaming Headset', 0.35, 'Peripherals', '2024-01-29 08:00:00', NULL, 1),
(6, 'Desktop Computer', 55999.00, 8, 'High-end Gaming PC', 12.00, 'Electronics', '2024-01-18 08:00:00', NULL, 1),
(7, 'Webcam', 1499.00, 36, 'HD Webcam with Microphone', 0.15, 'Peripherals', '2024-01-05 08:00:00', NULL, 1),
(8, 'Graphics Card', 25999.00, 9, 'Gaming Graphics Card', 1.50, 'Components', '2024-02-01 08:00:00', 0xffd8ffe000104a46494600010101004800480000ffdb00430006040506050406060506070706080a100a0a09090a140e0f0c1017141818171416161a1d251f1a1b231c1616202c20232627292a29191f2d302d283025282928ffdb0043010707070a080a130a0a13281a161a2828282828282828282828282828282828282828282828282828282828282828282828282828282828282828282828282828ffc200110801a901a903012200021101031101ffc4001b00010003010101010000000000000000000002030401050607ffc40014010100000000000000000000000000000000ffda000c03010002100310000001fd5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002b12f91a4fb6787ee000000000000000000000000000000000000ca733dd69e2f3ddf088fd2c26000000000000000000000000000000219eb27476b29af4d04b665de76f8c4afbd81a66000000000000000000000000000022317262895e473f6d3346ad85d742f394764539b3ccf434f9b61e8a9b800000000c57178000000000000000182722157349ca3b79cc17ccf1fd1f33e84b61e5f4f4fe77dff009031cdd367aff3d69f4be8f8bacf4c0015e73601195679f2a321f452f23d7000000000000005376025559d2dc93d0324b591f2b4e7356fa2653e07d35c66f9efaaf9d3c19f6c212ba9347a5e27ac7d0cf16d00c5934673d4b3e4be90d3464a4c55edf30f6bd4f2749b95d80000000000038669502bd5ca094efc65d0d19c953dda65869bce81e1fb9e11e2e885e66aedace6ec579edfabe27b04d9282ac9a6b3c8f7fc1fa42985f98e78decf867d55c915ca559a3b8ef2d000000000c9af117e3bba4e98ec32e8cba8cdae8811dd180bf9d00781effce18afa6e33d3bb79e46ff5e664b34c4cf0d194abb11e4fd47cbfd297d13b0f27c5faff0028f4f889def2421674af4f9facb8000000814d94dc61df8ae29be59cd14ecc46dc37c8ba9ed8480073e6bd8f30c367387b12c1ea17f6133a8f09c7923cfa3dbf3cf0fe8f17a0727c9123847ae1d4784a318928706e00000a4bb16bcc68cdab21751a721b70dfd236e5dc61df83794df55a003878d93b516e4db9896cc7a4f4e7e66d35763312e8e83870ea312cae30251ae2591e7401285a6a00005593ba0cbba0239e798f4b27243561da62d14f4d0b2a3400079de8fce92cb65e67b33d857ab2ea2728c8bf6f9733d4b335a5aae2763081642038e8e75d39d00397e7d45c001cee429d5c90ef2b29ae5e692f4fcbda77464d05f9b5643d1a6da8d1ce70972351932c2a2375d8cbb2eaa4869cda0b25099d946468d79750859595bbc000001d1c0afd0f37d40001835e72e07735f98aa13de7876e7e9a34e2d46ec7a729e843b12ce7077c5b227215ea28beb144adca2fa6e27284c94a3334eacda457656479de1c7471d1c01d07057e979de880018b4e7d2452e1451665356e8f4f9fcdec7866ad58751bf3c387a3ce526af2ebe13ccda77373611a3b719ebed24adae64e509139d561b34e7d02bb2b23cef000038001c39e861dc002078de8789e81ea5786268aaade6ae7383c0f7607cd4eff0034f42dc1a0f63cfb879f30be32e97d12b49e3b2451f19bf51eb761d27d8489db4dc6dd19f40aacace71c3ae000001c709edc7b001e17bbe01ab9d15fccfd37cc9f69a7913b1e40946102caa351e765d3f107dbfa3f09f507a19efb4c96db699efb7197fce5feb1836db419250913947a4eea6e37df45c2bb2a39c0000383bc70ec3b03569cfa0e81190c39bd7a8f92f4adf54ec3903b1e4057dac8f9f7f9278be2fb388c5dd151eefb5f11c3f43cff000ded9bfd1f437118db028cfab199e5191294244efa2f37dd4dc72ab6a3803800e1c3bce057640df6c2674038723c81d84604a300e38469b6063c3ea527899fde89f3b4fd3d87c8edfa9d8791ecdb323d98af9670a326ea4f2bb3a4b650913d19f41e85b55872ab2b38701c3bc70ef23e41ecf9be3eb2ef5f3fa05f642675ce9c8ca2575db59557740ad21cece4551d1d32f360c7ddbd325ba7a53db7a53db056b057cb0534ea81e6f97ef623cebf370dba72ea3d19d7610ae758e387799fc53def1bccda64d7b35146d9e817f2c3b20741ce8842de14c6f142f154ace95f6c10ec873a0000071d1c74463670cf9f6d4797e67d0643c5f63cfca7d5d9e1e93757e47907d078b8b69936ebd466d57dc53a2db485bd99c972473a00000000000000000000000721670a29d703cec7ecd27cf51f4759e05becf4f3b4ecb0cf75f615596488ca439d74e7400000000000000000000000000464210bb8511d1c33f6f14cece90ecba73a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007ffc4002e1000020201030206020202020300000000010200031104122110200513223031322333405014243441437080ffda0008010100010502ff00e5e67022b061fd9bb044d5d773d95eb181a35a0b7f63e612d787b27c1b36b8f0cac5c3fb0b9a0180047c6357a46d405508bfd5330506e85ac31a6e220bed58b9827c46e4b1d8a9909fd4b5b981392e26d66842a42d295c982398a220deff00d41200626d870a3d564c2a0672d3cb9f2546008780393698abb48b1a2b06fe989c0e6c2cdb42aee2cc1061ac276a076679526d03a1e4b1d8bbf90f0374adf77b976a56a94da9727f1c9f34b1da1177166da154b17608305e5fa8145956a2bb20118c513c4b511841c45b8acaecdc3311b72fb2df557c4aea4ff20107f8d69dc7e22fe42485080b9660a154b9b0850d579e5507976d76d034babaef2e726c53e653f15fa587a2c56f26c4694b6db3b1dc20a7554dcdd6cfd7e9f375b95d3f850c687f896bec545da1fd6c27ed7f80bf95890aadea3a74e9cb3dbe1b629a15826b46359f5beee1ae5cd7c595695f2a4f08772f5b588b2fad750b5e7674b88d97bd753ebed5b74be1e42e8ff883f23d8db56a5dab69cc5180ff009180c427cc6760af558962b9c0a9703a7880ff0062e18b6f19a579af4ff09e8d4299a339a7ada33673b2872de2ad7086c630c2011e227f069d71a71c156cff000af3c0117f258c42ad2a65adb56a5dab7198dab42e4dd48b251bacecf11fdba8f9233569bf5a7175fc58a6684f3d752571435750d273e218e87a789feb518189881a039fe057ea371f4a0c2bfaed0227e47660ab52cbfd4ca301f98381d75ffbf533ff001e97ebf176a7e13e3427f317021b61c987e511459e1bceab10ac3d3c4b96ff00be8799f0437bd79cf45fc96bb6c4a1702f3c20c0b3d767d469c6e32be7b757ff002f51f73faf4df56fdd656f68ab4a444ad5663a1862fcf847ec1d2ca730f0755ceb7333d988ad01cfb95fa8dcdb2ba976addcd806257f92d76d8b4ae06a4f08302ce7b9fd5aabb9bade29d356485a2b53898e988447e3af847c0e80c601c1d16756526263b13f7afcfb579e00c4b0efd40e051ea37b6daea5dab6faac03113f25b1396ec27028e67cdda9fa69ff00473fe4f695063d6523709e103f1f41d0f6e672670b14eeb7d9660a13d4ec70295979c5750c0b3d57fc0a3d46f6db5d2a152c380a303b35adb74ebc574f32fe6ca1f64e1803da3a5f4135e8b48da7ab64c7767a644cf4a7f67b367aee968c8496f368e051ea3a83e8ac616cf5df3e6cedd69dd6dfc5750c0f9b5623158ac1c7227ccc4c7b391399c09bbb68f9ef16a6e63b5691c47313e17d56ea0eda691816faae1c0d3faa1f8abebda87ccb2df5dade9ae958b04112cccc62039efce26e86161093dc669febdd6b6caea4fc5e4e209636059e9d3a9f4e9f95d4f253e2af53ea4e29a8605bf1dbae7c543d35d4332f392385483aa59b670e33d999cce042dec9947ebeebfd5675b30c6fdf626fc55a6fd7673a8276d7a61e9d472e9f5f9b7b4b79d7de7310602fa9aee027c0ec4254ab8331d0c2d0927db6f8a7f57753ea3d3e3a13b541274d47d473a8d4714551b9d4ff00d57f6ecd659855f4ad7ea379c0ac601f558bda22753eed9f55185edd49f428c0e964335a4f927fe369cfa6bfdfa9fa55f09cdcdf157d7abb0455cb35a77b28c45fc8d69daa83117b444ea7ddb3e3bbef7f53c963c6aebff47e68d29f4d67f36a7e2bfad1f6795fd3ad8de759636c5a5302e392a313eed61daabda22753ee9fbf6d8db1295da9d1bea7e00dd6dcbbeaa4e6ad21e071a8d4fd6bfa69be6c89fafa6a1f79e2b4405d9dbcb152625a628c06f53af41d444ea7dd1fb7b6ef559d5fe5a69871186cbebf4db67175fcd151cae9fed644fa4b6e2f06da9466d63b6b5552ccede584596980600ed113a9f76bfdddb503bba7c096670a36acd62655f8377280eeab4ade9af8b9e07544776b612b580ad6312b52a86b198ad6aaa599c840ab2f7c0e83a889d4fbb4fededbad76f115b7a3c3291bafeba9a76143c52712a3b6c7e2e3cadd81379312be4d81222331665ac22b3b330ad402c6c6da35b79b7507edd8b13a9f774ff3d8ec11743934c0711b50ab5ada96d342ecaba9e45fa52b0b724e639dd5d4db95b999c4f5b4545506dcc4af96b0245424b90a35ba876b345a35d357dab13a9f70cd37d7b3c54ef53f31db6278d9294e9ea5a28eeb02b86d3b2953b0d4db5e30cce44dab37aacf5bc4a82c77c0bacb2f7d2e952846e17b562753ee1947eaec6561e21d31bf51e1bfef78c76e613099a8bf60bf5361b69d74d35e2c5067ccd89005137625d784502cd54aeb5ad0c7fa8ed589d4fb8df14feaec2321a9c4cf3e217f93e17e0d47f8fe1fda6132eb26aac331310655b4fe2640af5b43cff26b11fc474eb0ebecb4d1a3e718861967d476ac4f7dfea9f5ee601d759a0a75673dc63996f32c5cc2936cc4c4db982bccd2e80b9a284a4018ea65bf51da913a1f74618afbed1a3ac6486b8d54f28cf218caf4999469008ab800761962e40ed489d0fb5ff566ad040d65a6a1883bcccccf71108856149e5cf260a22d116a026263b4c696ac56cf6245e87d862156dd708de65c6baa5691441dc6187bb13136cdb364d902409313131dec23acb1623e7aa45e87bac74a859ae26157b192a895c558a20ee3d989898e989898989898989898f6888c23acb1223e3a245e87b2ebaba65badb1e0acb15ae2a4558ab0083dac4c4c4c4c4c4c4c4c7be611088e92c48966c95f317a1e976aaaaa5bacb6c8b5c4ae2a40b02c0b0098f6f1313131fc53088c23a4b2b8acf494d7a4ff00374f2cf10ae5ba8bad8a912b8a91560581605807f4e442232c7ae3533c89e4c14c5ae04816058160131fd4e2110ac29364d93640b02c0b3131fd6e26262626d989898fecb131ff00ba7fffc40014110100000000000000000000000000000090ffda0008010301013f01367fffc40014110100000000000000000000000000000090ffda0008010201013f01367fffc4003a10000102030504060904030101000000000100021121310310124151206171812230324091b104132342505262a1c13372d1f08292f180e1ffda0008010100063f02ff00cbdfc08a8b4c47c50b8af5830b80ec91ee9dff00da37ea5d305c37f6c525c776af032564d7cbd612c9ea2bcb2f891c30c214a8325a144db81013c54239f34df497300025623e56d3e2381bda3f65014ba0e826318fc3645ded3586e41ad100243e1717182e8363c576a0a6f778a91778ad5173bb476239a18abf0a8594f7a8ba677ae8cd4d4d744289a0d9c67b229f0989905a33cd4e4168d535d190535858a036300e6a2d710a623c14be0d134589d26e414f92c4f5e4a27a889be39a9d7acecda3b7b59158ec9c1cdddde3e814dea2562728ac4f5e4a2e4d1eaf10ad5081c31a63947630b79f05887fd5898a3da67dd48c9445547aa377ae6c438c8c33e2a47bb7ab14f796816234c944d02c4ff0d144ac4eba0e58480468b17a298815b233f050ecbfe541833af056ad33388ac272922df050c9cbe8756e864ed98b916d9bfa43dd323b0ee0aceccbc073c470ab5c8d1321bfcfbacaa6416f5805056efa053f95a0588d3251320a2e588dd01ff146c5f8b8c8a8da7ea1ed277d4015c535ca22b740d4295503aec4b45a3c765d9b50c4ec475d6f2996f6b673b16cad23afbab1b23071155640e9dd71e546a9768d2ec033af0bb00ec8aef374bb2288083cfed115ecdc0c3ed744d4decded4c3791a15c6e86861b078263a441cda5749c60dc501a294d7f1741c011a14dfdcac87d02edfdc83055de4a4b165922e392c4ea9aa9768d2ec033af0b8bcac5d9b41478aaf69ee9a8a3b62c79fe1338dc3827261df75a0e0762da21ce696c086d4f043d0daf746cc0807f695aff0096cd9f340682ed56bdc4da6b4e0b08abae0d146d78dd8f2cb8224e4b13aa6a8598e77068cf66cf814ce3704503bc5cf1f4dd253bb106f48d4ab53b8f9ecd9046fdf74fae1663def2b8bb2a045c7253ae6b00abbcae0d146f9ae08bce7762d69b3c1a99c6e1c115063712e9bbfd57446c856c775f16d540d55837879ed4bc14a63ad2fd69c11856838a826b06533739f9502254ea833e6f2bb0ebb56877c10e08a9502c44623abba9b5ff001d8984db573e4d840055dab687665e39fe3ac0c1ef795cd6fc8311b8bf53152a990524d6e93b9cfca82e2ee5b312b11ce69ca09904d19602471fef9ed4d6ed53f81569c47590fb21a0eaa2539c780e0a28b8f69d3440a9929203e5bb19ce6a55320a4b7a86cbb57746e8ea82fa50872214ebe7b6f1679b488221ce05c4c65b73ba74d83c3aa0dc9b3375651a28ea983418ae2ef98c561f9a5701f2f9ddc3698cd3a4a02aa5447c2e92fc2d429759fc5d296cbfa8c38845125171a9b89f94479dcf3be09d0aa9203e51717fcc6374759ed39ff31fb2e174f9ec74abaa97532fbae9294fa8771db2e5070c51d541ae706fcb517ceae22e8eb3566ddf1b9c77a30a99295143596d60157cb95d1d506ed42a1441e6a7e3b1aafe2e94bb8b19ccec43ee801025ae8e914e8d426f0437044a0acdbcee1e3b45f951a833fb05145de0b08da92d2ecd4d6bd6b786dbad35be3744f129ee35373f9275c770b9c796cfab6f69ff0060b458b558456ee1de00dac22ae9285e05d2cdc023c2e7a1c6e7f1bb9ec173a8117beaefb2c0299dd8b2cb82957bf939365b11514635043bee8a09e99fb85cefdd70d897e9b69bca90e91a0539ef58073ba3965de1bc76895befe3706e49ecd442f726f1171e26e6f0bfd5b29ef1fc28990589de1a2d4e4144cce6b00ae7b85db879f776ed359ccec70b8bb5b9edd66138206f771b85d86c8cb37ff0a72016234c8289589f5f25a9c86aa2667358454fdbbc72da739d52764015280141707b6adf24d728e97beee9184d43b2cd3553e4a2fe4d512b13b90d2ec4eaf92df90513339f78770da6d9b1c432c598dfbc9934799f05d2ba1762c9be7b12ec1fb2c2516a2134eb7622ba039951333a9506cdcb13a67c96f589d5cb75d88d7cae1e8f65afb43f847bb3f64b9c60d0224a36cf93fd21deb4ee1ee8f0ba4adad6d6567666bfdf05ebac8e2b339c108d4ccec40cc2c5633dd9a8893854141c1445d02a1866a660372d142cc7351333aa8099589d5f2bbd47a34edcd4fc8a537e67bbbb8ecd97a283faee83bf609bbf8e7797c224506a720bd1bd06ca768f313bff00a559d9328c10dbe988af66710d0ac2543234ba46054dd05331e374ba22e92365e8d5f7ad3267ff005419cdc6ae4ee1ddc6cdadadac86116765c2a7efe57b1b933da1fc7e55b7a51fd3b3ecf90fcf532516388586dc7f93549c1dc2e9cd76029085d173a01676761ae6e41ad6e168a0173b87776f0d981a2f667fc4d141dd03bd5a5a51fe9265b87fc4c07b4fe99eb3134969d4287a4363f5354ad5a3f7497ea59ffb2fd569fdb3587d1ecf9b90b4f493eb1f90396c1eee386d96b8020e45599b5c7ece801977090535d11def77789a9a96dcebdcb72859fb43f65d332d07c0a5550323d7c5c4346a542c5b8bea728da3a3f0683abe7d646d1c1bc542c1b0fa9cb15a38b8eff84c1fe3d4fb474fe5155ec8601ad4a8b8c4ea7e1907767c9444c6cf6b13b46a837d98fa6be3f10e873068ba6c2de135db3fea57b3639dc64a05d06e8d97fec1ffc4002c100100020102040602030101010100000001001121314110516171208191a1b1f0c1d13040e150f17080ffda0008010100013f21ff00f2f274dad5d22f69461cc1ff00a9a601ef2ce817d017b507776a8ca80d4dcb546562b71a349d51f150852eadc6a1bb56a6e37ff48e572be6c7041d666f9cce9be9b2d52367840d34e56ae4bce2f4443b581e97ebff0045c05ebf273844143497303a88eb328880b96cb7df68560601b1ff002e8c0758eea75612cae8e8454e53dd2d3e9618cb5e4c29ea1e872820022c1eb01696b01cd841574cff00ca67896fb4fdcb6c3cdfac4360db9cdeb1c8876511f958af9f4086b0cd9260b662cd83f9ff0092c900dd886fc9dfbfa457fa009973d885c5039b17a2f321b94b03539c02d0218f7330364d1d57d047b81bd38f486d21e460197fc626401aac6902397f9615d96c0de2fa404c87c86f0da13409adc568c108f1979c10c198f1fac045f2239132eeb021ce41c37264180f7fe4a2b36ea041c95bff0060f6ef61cfcfb414d0d837ed1135dd0857b3b01bcbc16ec7eba4b4bd81bcb97444b73229e443daad21e93a3e528d66d12a2d8c1b3b8dbfd7c4a705a6a47561ca0ebfec384adbc1820ad121a34198463ccfe2749d2362da4c980d0a8ed7397b434d35fd6f3b0ba729819a0de06910e8fbbc62d5a9149743e0fdc67a5b06fd221d7715cba4677d8085aa8f27e2653129662b95464fcac357bced018d2b16fd9de6f0f2e88b068067dbdaa6b7d0d264fa6bf94cc7d2ef3ec03acd89489d8f3f0d94a3a16fa4240eb021e4e7c0abb8836c10d2d4255af4307a90a8aad7eefeaf38351d6606ef52f3627f691e506288390fcafad262c6835607443a3eeecd2511ad8ba72e9f7b4aca382835f55e4957946cb53e7a5fa41542258d2e5b3e857e20587241d39a5ef3600646258ac25d44b4db7efa44cd50c8ca5f417e027e84a7b7963add1e5003c166b5c46252dd08d1d6d44caac2f38f495281c529f4f28f65397bb06cc69fd4766dff00e9e71f49a018357bb2c6fe4c74ff00506b3da37743f43b1bca1446bd7d19fbde543baedfab3950286bdc6a79c3756832cb30df7f5c737d0f47fd9d4053da5e3ca1bbacd4f70990681f89a84ee8bf2fcf81ab562cdc0ca937907931f5f7b0e0556080d2fc263eea062e5c8ad46cf4950f31ec339847c31b8ac7e60e0e3fa4bf912f4dd280341333671d9febf134d01b4c8e6df5d22d15d1b7cf9412af57ef78ad2379236ff528f7406b1b78643e2340b2d628fd9d1c47a7cd48526c9d3f3e0f6123e9784641d3313d987c95310ce87f93ff003c08b3797761a7546706b60d6af46ba6d02c36bbeb3aa768f6e0f07357b13a6c1ed32292ce4c6bcc7bff00b1c39200c7f3ad19c132ae9b7a3ef58e04ac18d8de19015d23ea27e0f43f1360c04ca5d3f6e6fe2692708af36fae91f99204c2758fd30001a1e0c8fed6439edf0e8a3e8cfccf5e3de39ee40fbcd69cf2233a28eb16ad66bf7894c6e9afdccafd6abc28684d55c3c8efba71ae1d5a737dd65b9b0f3379db3fcdce4d5f2818a369d0cf6b5f7f88412f922baade575de63a26aa6dba53801d08baa07eb96be930bb026e0b3fd7b45a2e0b2fa3b3c39f63f2c367f58983b83d14f607e6115ac64d3d7480621e597bcd975c2ddbebc2d6b14d4f05a872fcca42aa59bab91d206813aa19deaefc37c36ce9bc585e7f5a4401500167f27a7ff07efce32f57d4690cc686062da1fe2fdf94a946d3e9007fb70952eb42675dacbdf7960f556f66bf83ce5393406b8fee6874f0aaad307915fb9e449f88fb418db4502b177a243ca0b1780d994e57dfc0f0373619742f459acecf9e0b892b1e96d176de0cb5ce6e16e354ae094063afb7f09c7bbf8d9d6317e5f7aca1469282d13e23f3e901d0265dca76dbdbe6328eb3dcae00828d023a5d3377dbf2f942004fb401fedfa4d09ed27e7ef4f08225065962eb37d70ccec7df526873d1296e84bf7cc1b128a5ced4fa1e1621a9ba6a393a7ed1da39ded333d0f66150ae0b9a61c2a54a77ed3c8edacc5a00d91b640b5fc57268ba983d3618074d1ce660d28afd8f4f758ca2b0de57069146c4c2743eeff97eb3d0215351ff008f6a8c9fbf300028d09813560806343c34b1d879c037a437ebdfaff95153e56fdf59a74b5a9fa94b2b2ef60cca151689a43e052ef135112135a92e3a253062a58ebc212b8e00b55ce93d63932f36089699f622dc2d1c8e19bff131bfc87df99cba4a8b58ae977d267e631f2d65f07cb316663b9f81ec4d2b0acba6fed368a982e87ddfe5c0a21e5e7e7f6fc5cb636efa1f98916a583ce15f8031f89add8afaf69be216bb8e8c6056777f730752fdc3f7300559b53c4a38b2fc1ca6fb4b4f2f54c9973d32cb727b99ab96debc5d26bbb1fc09dcb54e20e820b8fb8f6cda6e5f4086893c8e1e5ffb2dda851dd8246830768b927c9306664d53f4f608ea0786168b5a2593ce3e1ed1201a64f9e0f6b8875d359a5bf5f9335af3e0d4534ec90e863b3679cb2bc5bc8e8c3becf27c2f046a6a29d151a32f5d3d26c8ae6e91465c723f993ba4860e6ed030832417701d4c37e4c9e534620e6706b0bb069f526a262f31f77fe45d52ef2cc353dcefdbeb14bc87ce1724c115d3ac0d3c341f4cbfbd6519d3618cee539febdaa109a3f07d0f399ebae9fb9a4e03835576773b4c4b1c86a4198f4b49db8a76bec96a2f55cef5962ec3dd3572dbd7f834cd3eabf3e37cb4ff002fcf1359714d366b7f998d1057a14fbe90d40068ea4f463e22a5cd7dc9606c4d475ab7cf31f745f97fb50509e82fc4aa3f5b9cb81a3a9d1afab44b35aecce6c34f27fb7e91a3aba0cd20d380e36854ee4d6728727b4a6007ed0361ea601971d257f16a415e6bc5a1d2665abc76dbdb8dd15b4db3dd86f842e1a200a91e3d22b5c81f31e16a950d146847da27abfe4d272ecbebd7c17285b61f7202fc0d98576668874dbf7e729569607e5f9877050687c4bddb61fbf6f99b6108716a3fa154a74980f152751f46f00c6dc563cc67279b35050bf6cbf83836922bee87b478799f9e0e67b7d898cea3cd3c2e5c7f2b3334fded362622b149f83cfe251572f3993dafa737e268cbd01d618bd437e7ff00adb36c210f08ff00372673c78fae637e7ef4e2658aff00440129456f7852688e53d0a62bb45034e669d51e27e7cb973579b29b5368f5a6ec60e63320ace5e6ebf769a959cd763979c127e09abb167e4fe3d65baedb70108716a3fa1d0f4f8b7de8c1d6205e56578e0b9e12f6ad5c10f5ad4f63e929cd5fd44d6f94a29b988a97308b3f2f9a29fa6e7169e08566e5375e8fcc573012bbd2e0e472efcfd210d16e3991059636b9b32888b28fa749b2056c7b4c2ad5c7d72f9e0380e2d5c1fe6e7dfbf6f17451fe5f99db8abe9c22cf699deea3b1c1f6a5e53fedc7ea845d4b11d89a999735162e4e6c8e7ab46b1079087c7ed059a12538a0cb7cbf823b65546414b01cbcbbf3f485a366021b296651bff845016b73937616328301c2421fd3d90e89f13864d027a70a8d235a4d0558b7175e6c0c0828e0a62f56b7ddf88e974d165846b94bb3a4b08eba455b9d31e2611910737b1bcd36fa8eefd4bdea700202d233c8eaf36580827027d1d7e2589f42550e5abd1cbf6f94d377a0377944b504ca3f1d0ff660861af85aff00a367d0f1155904d334c02e8aea69044b113a47a79a6d3cd965b0f77df7e372e91f7e3b4bdea12faeda4e4fb922e5b8454b0b15158598c56723f10ecca6b0c45d23ee21b5e472ecfdca5995800f8823b07d6bd666ddb1f04dd2b01f0ff6157336d8d1dfedf4e715bf35e37c357f4266abb1e11bc923608469501d53e0270676d257c543ce9575e6f9ae6ab3e8adb5f7b8f415eb4f0b972882261122592bbfeae2623a154cad9d52892d32411eb001d0758a6854d6561e85fb4da4359b85d5a4ce7b755f71311aba04bbb7b2b4ecfdcc6a51774a6ce6f594ccacc497c49ab84fe73eaf43c2b5b370349f8083bb7a570afbf091e6291e0a8d9bdd17dddcd36a979f5e172e5cb972887cb7af93b4755f37a7d74f896a2872769af77217494eb902911a83a2a6e377a69afc89788759d7d25e2efaaef09a1492b86fa3d1287b9cea4e6c185cd0789e0cfe55cd13de2fbf8404decc3e86da15ad456b7c00de97ca7e6f226fd7d2f95bd22cb8b162c7894d6d3032f2dfbc57426db3dcfd4f3f229b3b41a00072497eb0d35ec2521218f55664ed5ae8ed723ac1f5a05147eb268f01e09fe56a4c3cd78498056118a710777c8ea7c749813ee71e4e8fcf4944e99d4947a1f56574ac5f5743c8a25c58b162c52ad6506232ce0d919b6652981935d9a7ccd3d21d7cf0fdb285b573acb9b472cbed2d4edd3f491967d91e49b8ebc4f633470381c3a383a31fe4794147c81e3c74d90b18ced16eae631b3162c58b1628f51b697ee6c5465e0522feabd0811144ac85eecf311890c74a68e0421c1a389fe4c10d8d6a68f12c58b162c597c1e0bcf7a7462ce8476883348aa2ad1088153738d4109c67260353c07068fe4689681aab412dc1e698f56f3451c951291349e162c51862fc09c472b3a3c393a40e50b94da612454a952a086641c068cb2853b73edc087069fe275772d106db7c8a3d357da532f94d8ec4aeb129da555e23e00f03857857b38078071952a54a9513818999ef44d1258d2dafd6b087069fe0191ae86a7b1ab3e6c87c8fdcea2455ff00e422a8e01f0443c462448f1010fe13f54a952a54a952a5711be7465abbb3fcfee6fc3a4f17444db93d3fb8a51f39ff008910b1f54b5f3858c4e8f813103c4c495fc440a952a578aa54a952a0e3774d58cf33cdbff88a8209a233471d5b82d89234bafeae84c9b6ecbe9e552ed4d7c61d2407f054af0854afe9541c4419ab446aac3915af295735d7498a01aecbcafdc27aab13cf9f9c5769d19d1f130012bfe22713196ed33e91e89d90b94e8f8ac122bfe3a4789023c33c040922bfe554a8c3e1e90457fcea952b895ffda3ffda000c03010002000300000010f3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3c834f3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf1cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3cf3470051091cf3cf3cf3cf3cf3cf3cf3cf3cf3cf2cc34c0c434c3cf3cf3cf34f3cf3cf3cf3cf3cf30a14d1401c208f3cf38f3c13cf3cf3cf3cf3cf28210f00f04f04d3cd3c23092473cf3cf3cf3cf3c228530b38f2c828730b0c72c92c134f3cf3cf3ce1452c900f3cb3c710d20900318300734f3cf3cf00728828f3cf0cd2481812ce1c934418e3cf3cf28808f3cc34f3ce0cf3cc0c430910b08508f3cf3cd00108f08738f3c338804704a10d38d3c53cf38d2c30cd08f1012410ca1c12cd3430c73cf0cf3c83cc04534330e1432c32073081453cf3cf3c73cf2cf08934b00f0411cf3813cf20114f3cf3cf34f3853cf0891031cd00114434420a1c73cf3cc08f3cf14e2810c814010114d08f04d0491cc2031c318c3c518320534c1ce28d10b3c314e3c80cc34328d00a28028a3830822001c818c1cd0ce38d3473423023c91c72472452473801c61c718628514b3431c52431ce0430430c73c33cf2c200e0470c724c0822003cf3cf3cf3cf3cf3cf3cf34204e34f00514a2033cf3cf3cf3cf3cf3cf3cf3cf1c50c320e0000053cf3cf3cf3cf3cf3cf3cf3cf3cf3c200000000014f3cf3cf3cf3cf3cf3cf3cf3cf3cf2c00000000053cf3ffc40014110100000000000000000000000000000090ffda0008010301013f10367fffc40014110100000000000000000000000000000090ffda0008010201013f10367fffc4002c1001000102040504020301010100000000010011213141516110718191a120b1c1f0d1e13050f1407080ffda0008010100013f10ff00e5e46a508805a0a05068f6746185ec927f695d1a3818ac00dd6d15d691da5062850daf2b664c3ce0a3a8b0a68a850d2c3cac03878ae252093a0b6e83fb20504b7eaa38d2f8187318c2a16b7571bacdac75d625320f32f98cb0d412a8516b5aaed414a25b973c0648185966ab67fb1a523258e6f3646fc994653e0867a146b4de506d09282e2e76734744b409a200a01b07f56e00735e0d595137ee9ed8f708cadb8c3bddf313b90be65502374f9861d9b3c203ef3db2b640d8f38e6ca92b089f6363a4bec2cdaf85a5188816aff54a0330f8f578df285b9d557a6436027c261fb8ddf6812ac85b245ca5681586bc1d0fb5ff00529c15bbc5d5383f03f47f522cc6f602061edff136679e930d8ee1d00cd8949f4f373f6966d21e71ab818c58bb7578b63fd429bf0db6c377df18b17b50b9ab7894bdedec1b3dc8f9ac988d9399fd30f25ae0089703802edfb1f33324d69e842fec8363e5ce157de9e813c0d11cbf3da384c3de03775a76caf329873757565784813ea6c4fcf50caf7c390965152a2d0303189668d1361a9fc88553c03f550a76ac7a714ad83a2623b37ffa000f10337b35c749df8416e00cd67721103436d5cdda933b27367a1f3a4beb1c80d363bb8e84d673993d09fe02e9f9c5e52d9a1ee1694288a62d52b5262e285592f796f08efde7f5c10399e339b5be2e4de7c5c07e7462b2c8284a7534ff000ce96893f34cc6fc0b9616a8a250c35a8b6d0733f8b619fb4a150bdce4c4e25cda068d1b8307698866acad1311dffe67cbf4c955873b8bb738ac68bd80109edaf41cddc761a66ca7a87e006ee013c6588d1eeb36d8130995310b6c0355b13be480747cb9bb476d9882e41312e370d9f85cf9040d02e41b542a5a94b520d0ebaef956a9a5a68581bcc3518d38d70b52504d226bc4d0c7ab81095940c4d1a2eb520ae797a71f085fc293f06fd67e8287f279378fb8755b03d99851f8100c1eb876f4b6a53244e4055d827924acb19e1e8ac7e94986be78ec7401ef125c4550c7ad449678387fcba9a011782b5d8c5e533385cdbdd5998cb94ee7218bad8d65112a4630f3f07e3d4e64aba85e80041be378e6ec763758dec39876abb8bee73fdabf407d256978a6a2af909956b63da832945d0ea5ad44170d61d768c88606d1cefd1cfe8ea3f866cabb0b22656f489720ec27b5598977b96c1ea5511da184b8f7838799ea57d17514a2ab06ecc1af5b0371b0ba8af668ca7a5363cea1638d278ae62df497e6c3a1e8215352a941548c6ba996a556a8a9468e905223c36ba42a8abff237d1e567d4f01bcce3d965715760bb00eae639abbadd8e2d62c05ac068e0340584fe21a5b630211a743b42e799aac66c20ef6baacc66a7992cf4b6371c84b1bc68744a0817ced4aab81694a1b919b44b9b02521020e0c3724cba0f35e34b5afb18ff004b55f89b0cf6bc2645bf68d3de3ff4c547c3e3805c18fc63c0f400e168800dd62a841370f904b88de07d77ae9168089d1dd70fcbc447b3b7ce3ed29285786a56e68467e2700208607e82cb98acb13e0fb9281c9b5ff89338db062eb875ae50a187fab9b77a1d86b365f189c80dd6c4d779d2ab6a1b0b1cab9c0f776887156c2ec1bd1b9aabbaa9dd8ad1a67d854375634bb941f513b000a01b058267333e8645faca3312879ba570d425459445b0128d5d5b1aa56c12ad3d04bff762ff00f5b92a86d0fd82d4837f7bf53e27d20a89ef2aeca2b903d408f1285d82941bc3a2866b0201c404b8548514b76d118d167e668092821b710a7fa2c13fc7d8128b8083e1dae4faebce5c15f21f746540ea7f3922a8672bd9f720f963cd4a871b5e232ace986e9325e36190742d131406e23f2365802921fe5d8e2722bc88c26ceae81bb31e79d870a1b0b1d5ce7271f19d66515129146c7433743ca410e8140f47525de160fbe3020536907d5e30395f052de7dc488f989d05e6195237eb9fc1e63d5177b1f8ec3c39745978b7d7350ba9a52aaae2cde6f34afe143856736f8c44ee3c181a03b1f9327d1220274b0bf0e4f4ac36dce65d74fe64388ba47cb0e4b04126f5de5abfa8a4d968753801bacacd9ba8775cab6360885415982c66ee06e903b790681b1171546fac3b3b982bdfa48d884f2ff4eb2b10ff0007073eadf953d283ff007ab39c2f0d820512fa2561fb79c56313080b8dd59de77412f5453b0cadb486341a35529b5a5b08e05561e412eff4b6f08b806eed1f862e12c48fa46ea623a98c3233146260c4661a5ddd4fb3d12562465d68f246c993893201fc953ff047ca1931e7aa53c9981ea6b033eb8b172b3cec0f7ac0032939cdd7d2bd6a7425928f316c1d58d7e2535775dec6c13334bea31e0266ac79d062bb40082c3d392c1e90bc9166fdda095dc40d62c142181ab30e8154ad0b14c39eeab11f406861dce503fa3b612958d52acaa40d60e4bed4ac1d3fb9e12986c60bafc68aa3c8ca596bafad6dd8057206ba9c30ac841240405356c675acd8b8eb5cc95ddc9fc7401acec0c5e42003093dc100fe76491d085cc7789e2ac5490cd72caf42f2d5c0d0058f1346ff003f6306404475ccdd7d2bd7c48e2690574b7b38bbdbd2a5a0a9a04589a7e695f2ce56f18ac3ab7be903c60f5aaeeb1867464cf592dcd29c2b2b11701217a27b06c7c33485daa9f44e90a52a41085587498f0108fc2eef91de2d81a1caeeecba15de1480dc17f5cd6b06fc89b15756ff00c587f2ab7503de17250ea3467d5abc92527011575c290528fcae482bb2274c57a6303fb002c788ff00de1cf03b12d5dc1988a0e96c3b3b999b68d9b15e98cb2e8390588c38a9cc6c4c17da1e9a100055d6d7c55e93a431cf8f7ad0df9760a1e61fca3470aeed4ce34470d8112953468b5129451118f4ad2072331d9e8bc4bc10850a8aeb29b8522c140a391b4003675b1605bbce846208e19092915080ad2dec3b62f5a42d4acbe833f30099e2801183661e5fd7f12a93dd258e85fa2040c8eb4c235c1852adb720a119bb8d49f3288fe63a40405f831fec3ac63c46b33a54c2d523d457ba781dc4a41a417f27b963c791eaa2ab5ba357c077cb6a1ed36f88f6f3f26427d15a5df2f64f799e658734838c0ce76d1e49dd471f9879e702a00c5507808245b82a32e9494948d2fb7cf096aaf25cee9ec4543e52e6fe58d6a1dcfa53b456a6e173e80d77bd8abf3fc08c0955d52988571e92d40e5d21f19db4b91b181ca368c0ec5eb09f96d69b7c13ec9857de57f001879660f49c814200798eb67b0cc43227e0c4b6f21d6541962b16f43878a7a49280c58d98cc8a0b782608cbcea83c931f257a488eb1e52be0ad3a475d41e048940d02729e1182f83be12aad53dc874773a8c22c431c62bee6e5bd4199d4f2f231664035fc31ef494a1a874f466ecc13d804515d8443d4c56abd8f58d2ba9058755083c0a101b7aa359760e990ad4a6a3254d4984648b7714aced49a2dae814e9296d907fa9ea9e23654e517dc1c257f8ba80f31946bcd5421e0d000d8b1e08950ba0dab8f62f0000c3d298c879737b5a0e936c03165fc07395c1d0752cc628f99eec01fbe2fc54b87da21c5f10a8ea3489f1b894d465adb7d0997b6f0bde2bc3fcc1df08a695a6d73dff011ace4171cdfcb3cbac5f88ad4dc2e7852043d0a8a1a3ea7cbd7427fdf07bba10296e21414d9900deba51a224c42c92d410ad42a5621b919414d6d252b7960fd227fb76043c18928e99e75cf2c70b03a52de504420d2d6c7e0f9e2b2bc193d43d3e3d4d5e54818117e8313a93f73838b3721d254f3e0331d85378e2f42fc8949960e21c3b8300f32087ca3a394a0570eaa9ed2a67dcc02abbebe20bd803f2ca2390b0e0a4a7f03a4a9e331dd7f9f528cb612af6d361f01c53933ddca2d13ba56af3c9177f13a30fcae5d3096fd13e92b5ca6b11ee8310fb1e46468f29d49d8aac562cac61ac94ea60adab81d530983d0d000c597dc3a265f66adf645abcdd067d20502521362850742247ec1bbe9675718f887085a3c0ff1578547a0cff28c3d4da083e995baccb31c686a3f012fa7f888e27305dc1de16f312c7612a3ff003d5f33e9dd9052b9d3eedfc915483edc1a7c458c314cb2dcd00d55b066b05d07864360d82dbb573803ce321f7c55d8ea4d701ccb8b0ead3a271e615e4356586a29ac781cbd886300f9579f108bd34e23e9a7a2bc79d477dbd75aad8ecd715dedc1843409ba4f6604fa88133201d823d8a93ab32bf2f286fbdb2a7d4bc52e77f743e250954df1ee5630c1500b929cce0c180f2981d5cc99c88c3d7c0d8315c81662d03a9b8ecd032012978719ac303aab1a15729f88034b6c6011fcee32eb6180c9cfd0869e8e41ff00085faa4f35f50506ae71803ab49dd330ae2f5c78bfb019c43f60a6128fa9ce8eb1a9407ae0284e669dd6bd8d27d638a4fa5564abd117d2cdc23a725165663ad3d604f774d6112bed15d10def7eae3a2d91adf219adb81d315c00ac6158fadeca6c160c8355968579d602f35b376b93069d90d002c0d82273cbcd99e43cb67d28701fe414f40a375793d4e8ff000d73e4e84a7052030607762fe3a4a49d3e595b1ee536bdebe383bf1bbd55f8ba4dfca75accdafbed66829edbc3d9252ff7aa3f31456d93d949790a2b96f9aa7de9aceddaa010bfacb72685ae7918b7a515db1d7f6b29b64e36be3cccdd19d73a998d2700fce01766391e44f0a9b163ab8aca4193aa8e29b56819a84c3e0ce218f75bae6b2cf421f487d34f5b0fdf163e7d48e519802de0131e07924f381172026128239d4f12cc21d0b465cc4a8c4b80dc45d127e14031623240ebfef996c1de5a6eabba53e25612b5cc80cda05557ca55aa3c72fbcc0d9d560fdc28bb01ed31ab0c51a7234310ddc3f39d770dd567d9f1d757db25ef3e578d5b0062ae0118df47115f23abf02c35ce253127c046aeb30a5303c0d5ac0c20a287010f5cd7d15f53088323cbfaf53364546a5c8018d94b477375189093866aa4b1d47b13efb02333a7decf82bd9c2b1a2356d7c7539b764f4c8afee7a64c5fc8a1c26b81de9a68bf23829e016d703b91fb5096b17c4e7054b9681b14deb3e3136eb809f424837eb89daf09dc57a2ba0cd9e52e15e8e68c7a0cd7a4d98ab8062ac638338c0b88735cfa0b555fc7652680347bf012aac1840fa43fe2af1529b5ed55f9f4daf4e604aabb045fe060800887ccd6045d52e3a3ccc18cdd15c5a4b2a6540555119640686b4b104401a85c84171fb23c8a1d22c61827cb6a411b224cedcbd50683936c79c0562ae141c4468ee33f70d1c661447a578e5a27df118f46f396b383a2a547267c908f347b13ed675d577627b623f9e44c392fc20c06c639aca48ab54d3c019ad0261b4ba03973e6a8b858ad69a8a704689fb0f10cb1d260e038e5718b8060fa40ff000abe85313abf620fa190572002a0ee08d4a9a68c01906c108f4adf344e817acbf529626b3631729790a3c0505d066b77558b18619659ddd2607228f431052e83e589ee8f5fa732e5a51c9957c4dd873255aa31503980ecfc33ce34f4bde09e541db09fb40f6c614ff522980ebda79200f3b8bec644388a8a3e3db465a78098b06df9b8a4137d032b418700fa03c0ff00130e9068daf9c870af030489555572b83580284b28e0ed11fab46f536d68416587556c72368ab84fa13d1f403636eba0da1a89b23299be12beabd7068c1fd6a0fc8ea34494203b8901c31f154118b2bd581f95da765217a6bbaa6586b00e7ababe8288843817f345e0a90343b3baac21c42d2a054471123a77dc1f473114d6ef22105d70c0bd9a0ba2251182e57a31d94bb2e1027211e711f5a3d0ae1c17571ae05d5c50ba9346049e17a91ca758217b50765874c013de750024ec49f6c2aa33e59faaa4560e810fa4a7018fbfe11c07f1845782f0ac78527d99fe560103d2b0437a2cee22364952f058854a346cd28d28d25617d4cd52954948464e0c72f3263c02cdc20d504782941fc7338a3d6b2bc2bc71943ac5b0ed1560f42fae3d5858a2ac0a54e2c13899814e394622942448f059c744dfecca9b3e30e030e218381e158bc2b2b2bc1dad29ccad027474a7eee829bced490f4cfaaf1843d0fd334d52be8ab4af2ac2ac3270800f0028fa218781ab2bf7269f91ccce78c44dff0023121eafb8caf1acaf07c6b91e50b8bb1558d355074edea30a9aad9e5363b56140147020842523ea8d7829c0c35461aa103840104f457d439520e660d40ea4a67650fc3660e5a703f447162cacaf0d7210392d7a0439e5f9d05a1d4f29cd32c1b190d8a1c40429425083d0c107a1660e2524838649241fc0facbc717531a143ea16fa6fac2de8028b2bc29e26d45d387341106d29dc4ec0ba3318d5a732aab09c094e509438b0700958c3c361878049241041070ce0525252244f4061e24adc051821ddae46bb3132d21045e2826ccc2e0a0a840d83ca67d0c54d254b54855ced7b3810a30cf5895070a7a1230c3c41c1269284a7f324781af2af10c5fec7701c8ee232986b40f3513ccc53cabd280acb1a3e75d88aaa9c17baaf5125308a714e28fa9e728e01fd0313875382e830a9c0848106409c4e97029428e14e071094ffb938b5595e2217a9094b844d38d253807f4491878f9e19070b4a114949494fea12523c178c04a4094fec29292929c2bff00987fffd9, 1),
(9, 'SSD Drive', 4999.00, 42, '1TB Solid State Drive', 0.10, 'Storage', '2024-01-26 08:00:00', NULL, 1),
(10, 'Gaming Mouse Pad', 599.00, 95, 'Extended RGB Mouse Pad', 0.30, 'Accessories', '2024-02-02 08:00:00', NULL, 1),
(12, 'Wireless Keyboard', 2499.00, 38, 'Low profile wireless keyboard', 0.65, 'Peripherals', '2024-01-12 08:00:00', NULL, 1),
(13, 'USB Type-C Dock', 3999.00, 25, 'Multi-port docking station', 0.30, 'Accessories', '2024-01-14 08:00:00', NULL, 1),
(14, 'CPU Cooler', 3499.00, 8, 'RGB CPU air cooler', 0.85, 'Components', '2024-02-05 08:00:00', NULL, 1),
(15, 'Gaming Chair', 8999.00, 9, 'Ergonomic gaming chair', 15.00, 'Accessories', '2024-01-19 08:00:00', NULL, 1),
(16, 'WiFi Router', 3999.00, 19, 'Dual-band gaming router', 0.45, 'Networking', '2024-02-17 08:00:00', NULL, 1),
(17, 'External HDD', 5999.00, 30, '4TB external hard drive', 0.40, 'Storage', '2024-01-02 08:00:00', NULL, 1),
(18, 'Power Supply', 4999.00, 12, '850W Gold certified PSU', 2.50, 'Components', '2024-02-14 08:00:00', NULL, 1),
(19, 'RGB Case Fan', 899.00, 50, '120mm RGB cooling fan', 0.15, 'Components', '2024-02-09 08:00:00', NULL, 1),
(20, 'Gaming Speakers', 2999.00, 20, '2.1 RGB gaming speakers', 3.50, 'Peripherals', '2024-01-08 08:00:00', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `product_history`
--

CREATE TABLE `product_history` (
  `history_id` int(11) NOT NULL,
  `action_type` enum('ADDED','DELETED') NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `category` varchar(50) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `action_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `receipts`
--

CREATE TABLE `receipts` (
  `receipt_id` varchar(20) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  `subtotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `tax` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `receipt_items`
--

CREATE TABLE `receipt_items` (
  `receipt_id` varchar(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `route_optimization`
--

CREATE TABLE `route_optimization` (
  `route_id` int(11) NOT NULL,
  `start_location` varchar(255) NOT NULL,
  `end_location` varchar(255) NOT NULL,
  `optimized_route` text DEFAULT NULL,
  `estimated_time` time DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shipping_docks`
--

CREATE TABLE `shipping_docks` (
  `dock_id` int(11) NOT NULL,
  `dock_name` varchar(50) NOT NULL,
  `location` varchar(100) NOT NULL,
  `status` enum('ACTIVE','INACTIVE','MAINTENANCE') NOT NULL DEFAULT 'ACTIVE',
  `capacity` int(11) NOT NULL,
  `last_maintenance_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shipping_docks`
--

INSERT INTO `shipping_docks` (`dock_id`, `dock_name`, `location`, `status`, `capacity`, `last_maintenance_date`) VALUES
(1, 'Dock A', 'North Wing', 'ACTIVE', 5, '2024-11-15'),
(2, 'Dock B', 'North Wing', 'ACTIVE', 5, '2024-11-20'),
(3, 'Dock C', 'East Wing', 'ACTIVE', 3, '2024-11-25'),
(4, 'Dock D', 'East Wing', 'MAINTENANCE', 3, '2024-12-01'),
(5, 'Dock E', 'South Wing', 'ACTIVE', 4, '2024-11-10'),
(6, 'Dock F', 'South Wing', 'INACTIVE', 4, NULL),
(7, 'Dock G', 'West Wing', 'ACTIVE', 6, '2024-11-05'),
(8, 'Dock H', 'West Wing', 'ACTIVE', 6, '2024-11-30');

-- --------------------------------------------------------

--
-- Table structure for table `shipping_logs`
--

CREATE TABLE `shipping_logs` (
  `log_id` int(11) NOT NULL,
  `order_id` varchar(20) NOT NULL,
  `status` varchar(50) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `user_id` int(11) NOT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shipping_logs`
--

INSERT INTO `shipping_logs` (`log_id`, `order_id`, `status`, `timestamp`, `user_id`, `notes`) VALUES
(1, 'ORD-001', 'PACKED', '2024-12-03 17:00:00', 1, 'Order packed and ready for shipping'),
(2, 'ORD-002', 'SHIPPED', '2024-12-03 17:00:00', 2, 'Order dispatched with carrier'),
(3, 'ORD-003', 'PENDING', '2024-12-03 09:00:00', 1, 'Order received'),
(4, 'ORD-004', 'VERIFIED', '2024-12-03 09:00:00', 2, 'Order verification completed'),
(6, 'ORD-006', 'SHIPPED', '2024-12-03 09:00:00', 1, 'Order dispatched to carrier'),
(7, 'ORD-007', 'PENDING', '2024-12-03 09:00:00', 2, 'New order processing'),
(9, 'ORD-009', 'PACKED', '2024-12-03 09:00:00', 1, 'Packing completed'),
(10, 'ORD-010', 'SHIPPED', '2024-12-03 09:00:00', 2, 'Successfully shipped'),
(12, 'ORD-012', 'VERIFIED', '2024-12-03 09:00:00', 1, 'Verified and ready for packing');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accountdetails`
--
ALTER TABLE `accountdetails`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `carriers`
--
ALTER TABLE `carriers`
  ADD PRIMARY KEY (`carrier_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `customer_notifications`
--
ALTER TABLE `customer_notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `notifications_history`
--
ALTER TABLE `notifications_history`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `carrier_id` (`carrier_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `packing_details`
--
ALTER TABLE `packing_details`
  ADD PRIMARY KEY (`packing_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `packed_by` (`packed_by`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `product_history`
--
ALTER TABLE `product_history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `receipts`
--
ALTER TABLE `receipts`
  ADD PRIMARY KEY (`receipt_id`);

--
-- Indexes for table `receipt_items`
--
ALTER TABLE `receipt_items`
  ADD KEY `receipt_id` (`receipt_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `route_optimization`
--
ALTER TABLE `route_optimization`
  ADD PRIMARY KEY (`route_id`);

--
-- Indexes for table `shipping_docks`
--
ALTER TABLE `shipping_docks`
  ADD PRIMARY KEY (`dock_id`);

--
-- Indexes for table `shipping_logs`
--
ALTER TABLE `shipping_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accountdetails`
--
ALTER TABLE `accountdetails`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `carriers`
--
ALTER TABLE `carriers`
  MODIFY `carrier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `customer_notifications`
--
ALTER TABLE `customer_notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications_history`
--
ALTER TABLE `notifications_history`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `customer_notifications`
--
ALTER TABLE `customer_notifications`
  ADD CONSTRAINT `customer_notifications_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

--
-- Constraints for table `notifications_history`
--
ALTER TABLE `notifications_history`
  ADD CONSTRAINT `notifications_history_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `notifications_history_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
