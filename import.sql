-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 21, 2025 at 05:05 PM
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
-- Database: `miniproject`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `hospital_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `hospital_id`, `username`, `password`, `created_at`) VALUES
(8, 13, 'kar3_admin', '$2y$10$PE4krOU0Zu/Q6E2w4//NSubdmZQeGlcxD47AP2rqP44X8hEmtqhMe', '2025-11-12 16:13:22'),
(11, 16, 'gov_admin', '$2y$10$xhU1BJnL5k5YLR5jAKvBY./ocnpaYGsNTv7CPrTWF9xCcCjhtkKuq', '2025-11-12 18:15:54'),
(13, 18, 'pus_admin', '$2y$10$izMTSy5DgLe9qMZNYiZn/uYDtmCcUZrsKnWC2PNsbCtAy7Lvc0xlG', '2025-11-18 15:01:26'),
(14, 19, 'par_admin', '$2y$10$MIxCUfxfKaLewcML87u4d.TDNA56sWC1KSsBmW424HAUBvvy6gXRC', '2025-11-19 03:26:21'),
(15, 20, 'van_admin', '$2y$10$OoLJ3bz6LqbmL34fBXAWvO.qk06bMw7kPVOJiofrV8Fr.NSouub0u', '2025-11-19 09:27:11');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `hospital_id` int(11) NOT NULL,
  `department_name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `hospital_id`, `department_name`, `created_at`) VALUES
(1, 13, 'General', '2025-11-12 16:48:50'),
(2, 13, 'Cardiology', '2025-11-12 16:49:02'),
(3, 13, 'Orthopedics', '2025-11-12 17:22:34'),
(4, 13, 'Gynecology.', '2025-11-12 17:37:34'),
(5, 16, 'General', '2025-11-12 18:22:17'),
(6, 16, 'Dermatology', '2025-11-12 18:22:26'),
(7, 16, 'Gynecology.', '2025-11-12 18:22:38'),
(8, 18, 'General', '2025-11-18 15:02:53'),
(10, 18, 'Dermatology', '2025-11-18 15:02:58'),
(11, 18, 'Gynecology.', '2025-11-18 15:03:05'),
(12, 18, 'Psychiatry', '2025-11-18 15:07:40'),
(13, 18, 'ENT', '2025-11-18 15:07:47'),
(14, 18, 'Ophthalmology', '2025-11-18 15:07:56'),
(15, 19, 'General', '2025-11-19 03:28:44'),
(16, 19, 'ENT', '2025-11-19 03:28:57');

-- --------------------------------------------------------

--
-- Table structure for table `hospitals`
--

CREATE TABLE `hospitals` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `hospital_code` varchar(10) NOT NULL,
  `location` varchar(150) DEFAULT NULL,
  `contact` varchar(20) DEFAULT NULL,
  `registered_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `approved` tinyint(1) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `address` text DEFAULT NULL,
  `contact_person` varchar(150) DEFAULT NULL,
  `contact_phone` varchar(20) DEFAULT NULL,
  `contact_email` varchar(150) DEFAULT NULL,
  `license_no` varchar(150) DEFAULT NULL,
  `license_doc` varchar(255) DEFAULT NULL,
  `dlt_registered` tinyint(1) NOT NULL DEFAULT 0,
  `admin_user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hospitals`
--

INSERT INTO `hospitals` (`id`, `name`, `hospital_code`, `location`, `contact`, `registered_at`, `approved`, `deleted`, `address`, `contact_person`, `contact_phone`, `contact_email`, `license_no`, `license_doc`, `dlt_registered`, `admin_user_id`, `created_at`) VALUES
(13, 'Karitas', 'KAR3', 'Nedumkunnam', '9061144620', '2025-11-12 16:13:22', 1, 0, 'Nedumkunnam', 'AMENDA MARIA JOHNSON', '9061144620', 'amendamaria005@gmail.com', NULL, NULL, 0, NULL, '2025-11-12 21:43:22'),
(15, 'St.Thomas', 'ST.', 'Chetipuzha', '9061144620', '2025-11-12 18:00:06', 0, 1, 'Chetipuzha', 'AMENDA MARIA JOHNSON', '9061144620', 'stthomas@gmail.com', NULL, NULL, 0, NULL, '2025-11-12 23:30:06'),
(16, 'Govt.Hospital, Kottayam', 'GOV', 'Kottayam', '9061144620', '2025-11-12 18:15:54', 1, 0, 'Kottayam', 'Amal', '9061144620', 'amal@gmail.com', NULL, NULL, 0, NULL, '2025-11-12 23:45:54'),
(17, 'St.Thomas', 'ST.2', 'Chettipuzha', '9061144620', '2025-11-18 14:26:53', 0, 1, 'Chettipuzha', 'Anil', '9061144620', 'anil@gmail.com', NULL, NULL, 0, NULL, '2025-11-18 19:56:53'),
(18, 'Pushpagiri', 'PUS', 'Thiruvalla', '9061144620', '2025-11-18 15:01:26', 1, 0, 'Thiruvalla', 'AMENDA MARIA JOHNSON', '9061144620', 'amendamaria005@gmail.com', '1234567890', 'uploads/requests/Pushpagiri_1763477346.pdf', 0, NULL, '2025-11-18 20:31:26'),
(19, 'Paret Hospital', 'PAR', 'Puthupalli', '9061144620', '2025-11-19 03:26:21', 1, 0, 'Puthupalli', 'Lydia', '9061144620', 'lydia23@gmail.com', '1234567890', 'uploads/requests/Paret_Hospital_1763522729.png', 0, NULL, '2025-11-19 08:56:21'),
(20, 'Vandanam Medical college', 'VAN', 'Alappuzha', '9061144620', '2025-11-19 09:27:11', 1, 0, 'Alappuzha', 'AMENDA MARIA JOHNSON', '9061144620', 'vandanam@gamil.com', '1234567890', 'uploads/requests/Vandanam_Medical_college_1763544397.jpeg', 0, NULL, '2025-11-19 14:57:11');

-- --------------------------------------------------------

--
-- Table structure for table `hospital_requests`
--

CREATE TABLE `hospital_requests` (
  `id` int(11) NOT NULL,
  `hospital_name` varchar(100) NOT NULL,
  `address` text DEFAULT NULL,
  `reg_number` varchar(50) DEFAULT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `documents` varchar(255) DEFAULT NULL,
  `status` enum('pending','approved','rejected','deleted') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hospital_requests`
--

INSERT INTO `hospital_requests` (`id`, `hospital_name`, `address`, `reg_number`, `contact_person`, `phone`, `email`, `documents`, `status`, `created_at`) VALUES
(4, 'Karitas', 'Kottayam', '7410852963', 'Josna', '7894561230', 'amendamaria005@gmail.com', 'uploads/requests/Karitas_1762961653.pdf', 'deleted', '2025-11-12 15:34:13'),
(5, 'St.Thomas', 'Chettipuzha', '1234567890', 'AMENDA MARIA JOHNSON', '9061144620', 'amendamaria005@gmail.com', 'uploads/requests/St.Thomas_1762962658.pdf', 'deleted', '2025-11-12 15:50:58'),
(6, 'Karitas', 'Kottayam', '1234567890', 'AMENDA MARIA JOHNSON', '9061144620', 'amendamaria005@gmail.com', 'uploads/requests/Karitas_1762963425.pdf', 'deleted', '2025-11-12 16:03:45'),
(7, 'Pushpagiri', 'Nedumkunnam', '1234567890', 'AMENDA MARIA JOHNSON', '9061144620', 'amendamaria005@gmail.com', 'uploads/requests/Pushpagiri_1762963802.pdf', 'deleted', '2025-11-12 16:10:02'),
(8, 'Karitas', 'Nedumkunnam', '1234567890', 'AMENDA MARIA JOHNSON', '9061144620', 'amendamaria005@gmail.com', 'uploads/requests/Karitas_1762963995.pdf', 'approved', '2025-11-12 16:13:15'),
(9, 'St.Thomas', 'Chettipuzha', '0987654321', 'AMENDA MARIA JOHNSON', '9061144620', 'stthomas@gmail.com', 'uploads/requests/St.Thomas_1762970226.pdf', 'deleted', '2025-11-12 17:57:06'),
(10, 'St.Thomas', 'Chetipuzha', '7410852963', 'AMENDA MARIA JOHNSON', '9061144620', 'stthomas@gmail.com', 'uploads/requests/St.Thomas_1762970380.pdf', 'deleted', '2025-11-12 17:59:40'),
(11, 'Govt.Hospital, Kottayam', 'Kottayam', '7410852963', 'Amal', '9061144620', 'amal@gmail.com', 'uploads/requests/Govt.Hospital,_Kottayam_1762971335.pdf', 'approved', '2025-11-12 18:15:35'),
(12, 'St.Thomas', 'Chettipuzha', '0987654321', 'Anil', '9061144620', 'anil@gmail.com', 'uploads/requests/St.Thomas_1763472858.pdf', 'deleted', '2025-11-18 13:34:18'),
(13, 'Pushpagiri', 'Thiruvalla', '1234567890', 'AMENDA MARIA JOHNSON', '9061144620', 'amendamaria005@gmail.com', 'uploads/requests/Pushpagiri_1763477346.pdf', 'approved', '2025-11-18 14:49:06'),
(14, 'NSS hospital', 'Changanacherry', '7410852963', 'Josna', '9061144620', 'josna@gmail.com', 'uploads/requests/NSS_hospital_1763477449.pdf', 'pending', '2025-11-18 14:50:49'),
(15, 'Paret Hospital', 'Puthupalli', '1234567890', 'Lydia', '9061144620', 'lydia23@gmail.com', 'uploads/requests/Paret_Hospital_1763522729.png', 'approved', '2025-11-19 03:25:29'),
(16, 'Vandanam Medical college', 'Alappuzha', '1234567890', 'AMENDA MARIA JOHNSON', '9061144620', 'vandanam@gamil.com', 'uploads/requests/Vandanam_Medical_college_1763544397.jpeg', 'approved', '2025-11-19 09:26:37');

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `id` int(11) NOT NULL,
  `patient_uid` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` int(11) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `place` varchar(100) NOT NULL,
  `department` varchar(100) NOT NULL,
  `token` int(11) NOT NULL,
  `token_date` date NOT NULL,
  `hospital_id` int(11) NOT NULL,
  `hospital_patient_no` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`id`, `patient_uid`, `name`, `age`, `gender`, `phone`, `place`, `department`, `token`, `token_date`, `hospital_id`, `hospital_patient_no`) VALUES
(17, 'KAR3-000001', 'AMENDA MARIA JOHNSON', 2, 'Female', '9061144620', 'UIOPL', 'Cardiology', 1, '2025-11-12', 13, NULL),
(18, 'KAR3-000002', 'AMENDA MARIA JOHNSON', 2, 'Female', '9061144620', 'UIOPL', 'General', 1, '2025-11-12', 13, NULL),
(19, 'KAR3-000003', 'AMENDA MARIA JOHNSON', 22, 'Female', '9061144620', 'NDKM', 'Gynecology.', 1, '2025-11-12', 13, NULL),
(20, 'GOV-000001', 'AGNES ANNA JOHNSON', 20, 'Female', '9061144620', 'KTM', 'General', 1, '2025-11-12', 16, NULL),
(21, 'GOV-000002', 'AGNES ANNA JOHNSON', 20, 'Female', '9061144620', 'KOTTAYAM', 'General', 1, '2025-11-18', 16, NULL),
(22, 'GOV-000003', 'AGNES ANNA JOHNSON', 21, 'Female', '9061144620', 'KOTTAYAM', 'General', 2, '2025-11-18', 16, NULL),
(23, 'PUS-000001', 'AAMI', 20, 'Female', '9061144620', 'MALLAPALLY', 'General', 1, '2025-11-18', 18, NULL),
(24, 'KAR3-000004', 'LYDIA', 19, 'Female', '9061144620', 'KOTTAYAM', 'Orthopedics', 1, '2025-11-19', 13, NULL),
(25, 'PAR-000001', 'EMIL', 17, 'Male', '9061144620', 'NEDUKKUNNAM', 'ENT', 1, '2025-11-19', 19, NULL),
(26, 'KAR3-000005', 'AMENDA MARIA JOHNSON', 20, 'Female', '9061144620', 'KOTTAYAM', 'General', 1, '2025-11-19', 13, NULL),
(27, 'GOV-000004', 'AMENDA MARIA JOHNSON', 20, 'Female', '9061144620', 'KOTTAYAM', 'General', 1, '2025-11-19', 16, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `patient_counter`
--

CREATE TABLE `patient_counter` (
  `hospital_id` int(11) NOT NULL,
  `last_number` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patient_counter`
--

INSERT INTO `patient_counter` (`hospital_id`, `last_number`) VALUES
(13, 5),
(16, 4),
(18, 1),
(19, 1);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `order_id` varchar(255) DEFAULT NULL,
  `payment_id` varchar(255) DEFAULT NULL,
  `hospital_id` int(11) DEFAULT NULL,
  `patient_name` varchar(255) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `order_id`, `payment_id`, `hospital_id`, `patient_name`, `amount`, `status`, `created_at`) VALUES
(8, 'order_ReujBMVbLZpLVy', 'pay_ReujR7zjzo66aP', 13, 'AMENDA MARIA JOHNSON', 5.00, 'success', '2025-11-12 17:39:10'),
(9, 'order_RevUVAd9XHOI3t', 'pay_RevUcZwwSSC31M', 16, 'AGNES ANNA JOHNSON', 5.00, 'success', '2025-11-12 18:23:49'),
(10, 'order_RhDdRSMLExmsmm', 'pay_RhDdkMEkzpFULK', 16, 'AGNES ANNA JOHNSON', 5.00, 'success', '2025-11-18 13:26:54'),
(11, 'order_RhDgKeh39PRgye', 'pay_RhDgU7nz50HrE7', 16, 'AGNES ANNA JOHNSON', 5.00, 'success', '2025-11-18 13:29:29'),
(12, 'order_RhFNr9FogV1Wy4', 'pay_RhFP0jm6ZG2G7m', 18, 'AAMI', 5.00, 'success', '2025-11-18 15:10:22'),
(13, 'order_RhRrU1rnBpafXs', 'pay_RhRrqrMQ2f3VK1', 13, 'LYDIA', 5.00, 'success', '2025-11-19 03:21:59'),
(14, 'order_RhX1toFiBnWQub', 'pay_RhX28LYLCbe7MZ', 13, 'AMENDA MARIA JOHNSON', 5.00, 'success', '2025-11-19 08:25:11'),
(15, 'order_RhY1SAXbxNG0z9', 'pay_RhY1uIGsqCiTTc', 16, 'AMENDA MARIA JOHNSON', 5.00, 'success', '2025-11-19 09:23:42');

-- --------------------------------------------------------

--
-- Table structure for table `superadmin`
--

CREATE TABLE `superadmin` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `superadmin`
--

INSERT INTO `superadmin` (`id`, `username`, `password`) VALUES
(1, 'superadmin', '$2y$10$7k0rjzEhceGcdtLU3aRtoehfAiMvnRZztsmYuwge8vH1uIuMGiO2G');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','superadmin') NOT NULL,
  `hospital_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `hospital_id`) VALUES
(4, 'superadmin', '$2y$10$Z4lpu7Ggws0/5GLRaX5NL.ynhCDlRF3Y6DjDg9Q3JuBgjVBGZ3tEG', 'superadmin', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `hospital_id` (`hospital_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hospitals`
--
ALTER TABLE `hospitals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `hospital_code` (`hospital_code`),
  ADD KEY `fk_hospitals_admin` (`admin_user_id`);

--
-- Indexes for table `hospital_requests`
--
ALTER TABLE `hospital_requests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_patients_hospital` (`hospital_id`);

--
-- Indexes for table `patient_counter`
--
ALTER TABLE `patient_counter`
  ADD PRIMARY KEY (`hospital_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_payments_hospital` (`hospital_id`);

--
-- Indexes for table `superadmin`
--
ALTER TABLE `superadmin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_users_hospital` (`hospital_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `hospitals`
--
ALTER TABLE `hospitals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `hospital_requests`
--
ALTER TABLE `hospital_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `superadmin`
--
ALTER TABLE `superadmin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admins`
--
ALTER TABLE `admins`
  ADD CONSTRAINT `admins_ibfk_1` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `hospitals`
--
ALTER TABLE `hospitals`
  ADD CONSTRAINT `fk_hospitals_admin` FOREIGN KEY (`admin_user_id`) REFERENCES `admins` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `fk_patients_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `patient_counter`
--
ALTER TABLE `patient_counter`
  ADD CONSTRAINT `fk_patientcounter_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payments_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
