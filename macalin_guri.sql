-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 03, 2026 at 06:16 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `macalin_guri`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tutoring_booking`
--

CREATE TABLE `tutoring_booking` (
  `id` bigint(20) NOT NULL,
  `session_date` date NOT NULL,
  `start_time` time(6) NOT NULL,
  `end_time` time(6) NOT NULL,
  `session_type` varchar(20) NOT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `parent_user_id` bigint(20) DEFAULT NULL,
  `student_user_id` bigint(20) DEFAULT NULL,
  `subject_id` bigint(20) NOT NULL,
  `tutor_id` bigint(20) NOT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `tutoring_job`
--

CREATE TABLE `tutoring_job` (
  `id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `location` varchar(255) NOT NULL,
  `salary_or_budget` decimal(12,2) NOT NULL,
  `schedule_hint` varchar(255) NOT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `publisher_id` bigint(20) NOT NULL,
  `subject_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tutoring_jobapplication`
--

CREATE TABLE `tutoring_jobapplication` (
  `id` bigint(20) NOT NULL,
  `status` varchar(20) NOT NULL,
  `message` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `job_id` bigint(20) NOT NULL,
  `tutor_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tutoring_message`
--

CREATE TABLE `tutoring_message` (
  `id` bigint(20) NOT NULL,
  `body` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `receiver_id` bigint(20) NOT NULL,
  `sender_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tutoring_review`
--

CREATE TABLE `tutoring_review` (
  `id` bigint(20) NOT NULL,
  `rating` smallint(5) UNSIGNED NOT NULL,
  `comment` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `student_user_id` bigint(20) NOT NULL,
  `tutor_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tutoring_subject`
--

CREATE TABLE `tutoring_subject` (
  `id` bigint(20) NOT NULL,
  `name` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tutoring_tutor`
--

CREATE TABLE `tutoring_tutor` (
  `id` bigint(20) NOT NULL,
  `bio` longtext NOT NULL,
  `experience_years` smallint(5) UNSIGNED NOT NULL,
  `hourly_rate` decimal(10,2) NOT NULL,
  `rating` decimal(3,2) NOT NULL,
  `location` varchar(255) NOT NULL,
  `is_verified` tinyint(1) NOT NULL,
  `tutor_status` varchar(20) NOT NULL,
  `rejection_reason` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tutoring_tutor`
--

INSERT INTO `tutoring_tutor` (`id`, `bio`, `experience_years`, `hourly_rate`, `rating`, `location`, `is_verified`, `tutor_status`, `rejection_reason`, `created_at`, `user_id`) VALUES
(1, 'Profile tusaale — SQL insert.', 3, 25.00, 0.00, 'Mogadishu', 1, 'approved', '', '2026-05-02 16:29:51.631084', 3);

-- --------------------------------------------------------

--
-- Table structure for table `tutoring_tutorsubject`
--

CREATE TABLE `tutoring_tutorsubject` (
  `id` bigint(20) NOT NULL,
  `subject_id` bigint(20) NOT NULL,
  `tutor_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_devicetoken`
--

CREATE TABLE `users_devicetoken` (
  `id` bigint(20) NOT NULL,
  `token` varchar(512) NOT NULL,
  `platform` varchar(10) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_notificationlog`
--

CREATE TABLE `users_notificationlog` (
  `id` bigint(20) NOT NULL,
  `type` varchar(64) NOT NULL,
  `payload_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '{}' CHECK (json_valid(`payload_json`)),
  `sent_at` datetime(6) NOT NULL,
  `read_at` datetime(6) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_user`
--

CREATE TABLE `users_user` (
  `id` bigint(20) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `email` varchar(254) NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(32) DEFAULT NULL,
  `role` varchar(20) NOT NULL,
  `profile_image` varchar(512) NOT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users_user`
--

INSERT INTO `users_user` (`id`, `password`, `last_login`, `is_superuser`, `first_name`, `last_name`, `is_staff`, `is_active`, `date_joined`, `email`, `name`, `phone`, `role`, `profile_image`, `status`, `created_at`) VALUES
(1, 'pbkdf2_sha256$1000000$AbCdEfGhIjKlMnOpQrStUv$cYkp916j4rdYqIctd+I31e9AqAQ9YTcLVTkK0SnPBhg=', NULL, 0, '', '', 1, 1, '2026-05-02 16:29:51.541028', 'admin@sample.macalin', 'Admin Kaabis', NULL, 'admin', '', 'active', '2026-05-02 16:29:51.541028'),
(2, 'pbkdf2_sha256$1000000$AbCdEfGhIjKlMnOpQrStUv$cYkp916j4rdYqIctd+I31e9AqAQ9YTcLVTkK0SnPBhg=', NULL, 0, '', '', 0, 1, '2026-05-02 16:29:51.555075', 'student@sample.macalin', 'Arday Tusaale', NULL, 'student', '', 'active', '2026-05-02 16:29:51.555075'),
(3, 'pbkdf2_sha256$1000000$AbCdEfGhIjKlMnOpQrStUv$cYkp916j4rdYqIctd+I31e9AqAQ9YTcLVTkK0SnPBhg=', NULL, 0, '', '', 0, 1, '2026-05-02 16:29:51.565772', 'tutor@sample.macalin', 'Macallin Tusaale', NULL, 'tutor', '', 'active', '2026-05-02 16:29:51.565772'),
(4, 'pbkdf2_sha256$1000000$AbCdEfGhIjKlMnOpQrStUv$cYkp916j4rdYqIctd+I31e9AqAQ9YTcLVTkK0SnPBhg=', NULL, 0, '', '', 0, 1, '2026-05-02 16:29:51.576824', 'parent@sample.macalin', 'Waalid Tusaale', NULL, 'parent', '', 'active', '2026-05-02 16:29:51.576824'),
(5, 'pbkdf2_sha256$1000000$AbCdEfGhIjKlMnOpQrStUv$cYkp916j4rdYqIctd+I31e9AqAQ9YTcLVTkK0SnPBhg=', NULL, 0, '', '', 0, 1, '2026-05-02 16:29:51.586731', 'publisher@sample.macalin', 'Publisher Tusaale', NULL, 'publisher', '', 'active', '2026-05-02 16:29:51.586731'),
(6, 'pbkdf2_sha256$1000000$AbCdEfGhIjKlMnOpQrStUv$cYkp916j4rdYqIctd+I31e9AqAQ9YTcLVTkK0SnPBhg=', NULL, 0, '', '', 0, 1, '2026-05-02 16:29:51.620114', 'demo@sample.macalin', 'Demo Isticmaale', NULL, 'student', '', 'active', '2026-05-02 16:29:51.620114'),
(7, 'pbkdf2_sha256$1000000$AbCdEfGhIjKlMnOpQrStUv$cYkp916j4rdYqIctd+I31e9AqAQ9YTcLVTkK0SnPBhg=', NULL, 1, '', '', 1, 1, '2026-05-05 08:30:00.000000', 'teamit@macalin.com', 'Team IT', NULL, 'admin', '', 'active', '2026-05-05 08:30:00.000000');

-- --------------------------------------------------------

--
-- Table structure for table `users_user_groups`
--

CREATE TABLE `users_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_user_user_permissions`
--

CREATE TABLE `users_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  ADD KEY `auth_permission_content_type_id_2f476e4b` (`content_type_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `tutoring_booking`
--
ALTER TABLE `tutoring_booking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tutoring_booking_status_eefda9de` (`status`),
  ADD KEY `tutoring_booking_parent_user_id_9beecab8_fk_users_user_id` (`parent_user_id`),
  ADD KEY `tutoring_booking_student_user_id_ecc63609_fk_users_user_id` (`student_user_id`),
  ADD KEY `tutoring_booking_subject_id_c80dd84e_fk_tutoring_subject_id` (`subject_id`),
  ADD KEY `tutoring_booking_tutor_id_da9f54e7_fk_tutoring_tutor_id` (`tutor_id`);

--
-- Indexes for table `tutoring_job`
--
ALTER TABLE `tutoring_job`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tutoring_job_status_9beae769` (`status`),
  ADD KEY `tutoring_job_publisher_id_c14dccbb_fk_users_user_id` (`publisher_id`),
  ADD KEY `tutoring_job_subject_id_c80dd84e_fk_tutoring_subject_id` (`subject_id`);

--
-- Indexes for table `tutoring_jobapplication`
--
ALTER TABLE `tutoring_jobapplication`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_job_tutor_application` (`job_id`,`tutor_id`),
  ADD KEY `tutoring_jobapplication_status_b22da04f` (`status`),
  ADD KEY `tutoring_jobapplication_job_id_c23ba17e_fk_tutoring_job_id` (`job_id`),
  ADD KEY `tutoring_jobapplication_tutor_id_9dbdbbe7_fk_tutoring_tutor_id` (`tutor_id`);

--
-- Indexes for table `tutoring_message`
--
ALTER TABLE `tutoring_message`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tutoring_me_sender__a30537_idx` (`sender_id`,`receiver_id`,`created_at`),
  ADD KEY `tutoring_message_receiver_id_f1749519_fk_users_user_id` (`receiver_id`),
  ADD KEY `tutoring_message_sender_id_f1749519_fk_users_user_id` (`sender_id`);

--
-- Indexes for table `tutoring_review`
--
ALTER TABLE `tutoring_review`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tutoring_review_student_user_id_f1749519_fk_users_user_id` (`student_user_id`),
  ADD KEY `tutoring_review_tutor_id_da9f54e7_fk_tutoring_tutor_id` (`tutor_id`);

--
-- Indexes for table `tutoring_subject`
--
ALTER TABLE `tutoring_subject`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `tutoring_tutor`
--
ALTER TABLE `tutoring_tutor`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `tutoring_tutor_tutor_status_bcd88bc8` (`tutor_status`);

--
-- Indexes for table `tutoring_tutorsubject`
--
ALTER TABLE `tutoring_tutorsubject`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_tutor_subject` (`tutor_id`,`subject_id`),
  ADD KEY `tutoring_tutorsubject_subject_id_12f75de7_fk_tutoring_subject_id` (`subject_id`);

--
-- Indexes for table `users_devicetoken`
--
ALTER TABLE `users_devicetoken`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_device_token` (`user_id`,`token`),
  ADD KEY `users_devicetoken_user_id_fbc86cf7_fk_users_user_id` (`user_id`);

--
-- Indexes for table `users_notificationlog`
--
ALTER TABLE `users_notificationlog`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_notificationlog_type_da7cb7ad` (`type`),
  ADD KEY `users_notificationlog_user_id_7fbe866a_fk_users_user_id` (`user_id`);

--
-- Indexes for table `users_user`
--
ALTER TABLE `users_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`),
  ADD KEY `users_user_role_b5f37718` (`role`),
  ADD KEY `users_user_status_0a7b3b2b` (`status`);

--
-- Indexes for table `users_user_groups`
--
ALTER TABLE `users_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_user_groups_user_id_group_id_bb60391f_uniq` (`user_id`,`group_id`),
  ADD KEY `users_user_groups_group_id_f11843da_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `users_user_user_permissions`
--
ALTER TABLE `users_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_user_user_permissions_user_id_permission_id_43338cdf_uniq` (`user_id`,`permission_id`),
  ADD KEY `users_user_user_permissions_permission_id_ce09554e_fk_auth_perm` (`permission_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tutoring_booking`
--
ALTER TABLE `tutoring_booking`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tutoring_job`
--
ALTER TABLE `tutoring_job`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tutoring_jobapplication`
--
ALTER TABLE `tutoring_jobapplication`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tutoring_message`
--
ALTER TABLE `tutoring_message`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tutoring_review`
--
ALTER TABLE `tutoring_review`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tutoring_subject`
--
ALTER TABLE `tutoring_subject`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tutoring_tutor`
--
ALTER TABLE `tutoring_tutor`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tutoring_tutorsubject`
--
ALTER TABLE `tutoring_tutorsubject`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_devicetoken`
--
ALTER TABLE `users_devicetoken`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_notificationlog`
--
ALTER TABLE `users_notificationlog`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_user`
--
ALTER TABLE `users_user`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users_user_groups`
--
ALTER TABLE `users_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_user_user_permissions`
--
ALTER TABLE `users_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `tutoring_booking`
--
ALTER TABLE `tutoring_booking`
  ADD CONSTRAINT `fk_booking_parent_user` FOREIGN KEY (`parent_user_id`) REFERENCES `users_user` (`id`),
  ADD CONSTRAINT `fk_booking_student_user` FOREIGN KEY (`student_user_id`) REFERENCES `users_user` (`id`),
  ADD CONSTRAINT `fk_booking_subject` FOREIGN KEY (`subject_id`) REFERENCES `tutoring_subject` (`id`),
  ADD CONSTRAINT `fk_booking_tutor` FOREIGN KEY (`tutor_id`) REFERENCES `tutoring_tutor` (`id`);

--
-- Constraints for table `tutoring_job`
--
ALTER TABLE `tutoring_job`
  ADD CONSTRAINT `fk_job_subject` FOREIGN KEY (`subject_id`) REFERENCES `tutoring_subject` (`id`),
  ADD CONSTRAINT `tutoring_job_publisher_id_c14dccbb_fk_users_user_id` FOREIGN KEY (`publisher_id`) REFERENCES `users_user` (`id`);

--
-- Constraints for table `tutoring_jobapplication`
--
ALTER TABLE `tutoring_jobapplication`
  ADD CONSTRAINT `tutoring_jobapplication_job_id_c23ba17e_fk_tutoring_job_id` FOREIGN KEY (`job_id`) REFERENCES `tutoring_job` (`id`),
  ADD CONSTRAINT `tutoring_jobapplication_tutor_id_9dbdbbe7_fk_tutoring_tutor_id` FOREIGN KEY (`tutor_id`) REFERENCES `tutoring_tutor` (`id`);

--
-- Constraints for table `tutoring_message`
--
ALTER TABLE `tutoring_message`
  ADD CONSTRAINT `tutoring_message_receiver_id_f1749519_fk_users_user_id` FOREIGN KEY (`receiver_id`) REFERENCES `users_user` (`id`),
  ADD CONSTRAINT `tutoring_message_sender_id_f1749519_fk_users_user_id` FOREIGN KEY (`sender_id`) REFERENCES `users_user` (`id`);

--
-- Constraints for table `tutoring_review`
--
ALTER TABLE `tutoring_review`
  ADD CONSTRAINT `tutoring_review_student_user_id_f1749519_fk_users_user_id` FOREIGN KEY (`student_user_id`) REFERENCES `users_user` (`id`),
  ADD CONSTRAINT `tutoring_review_tutor_id_da9f54e7_fk_tutoring_tutor_id` FOREIGN KEY (`tutor_id`) REFERENCES `tutoring_tutor` (`id`);

--
-- Constraints for table `tutoring_tutor`
--
ALTER TABLE `tutoring_tutor`
  ADD CONSTRAINT `tutoring_tutor_user_id_b04bba08_fk_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`);

--
-- Constraints for table `tutoring_tutorsubject`
--
ALTER TABLE `tutoring_tutorsubject`
  ADD CONSTRAINT `tutoring_tutorsubject_subject_id_12f75de7_fk_tutoring_subject_id` FOREIGN KEY (`subject_id`) REFERENCES `tutoring_subject` (`id`),
  ADD CONSTRAINT `tutoring_tutorsubject_tutor_id_da9f54e7_fk_tutoring_tutor_id` FOREIGN KEY (`tutor_id`) REFERENCES `tutoring_tutor` (`id`);

--
-- Constraints for table `users_devicetoken`
--
ALTER TABLE `users_devicetoken`
  ADD CONSTRAINT `users_devicetoken_user_id_fbc86cf7_fk_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`);

--
-- Constraints for table `users_notificationlog`
--
ALTER TABLE `users_notificationlog`
  ADD CONSTRAINT `users_notificationlog_user_id_7fbe866a_fk_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`);

--
-- Constraints for table `users_user_groups`
--
ALTER TABLE `users_user_groups`
  ADD CONSTRAINT `users_user_groups_group_id_f11843da_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `users_user_groups_user_id_f1749519_fk_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`);

--
-- Constraints for table `users_user_user_permissions`
--
ALTER TABLE `users_user_user_permissions`
  ADD CONSTRAINT `users_user_user_permissions_permission_id_ce09554e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `users_user_user_permissions_user_id_31782f77_fk_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
