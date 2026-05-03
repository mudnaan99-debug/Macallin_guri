-- =============================================================================
-- Macalin Guri — MySQL schema (Django 5.2 + project models)
-- Ujeedo: copy-paste phpMyAdmin / MySQL Workbench haddii migration guuldareysto
-- MySQL: 8.0+ (CHECK + JSON waa la isticmaalay)
-- =============================================================================
-- Hubi: database madhan ama backup ka hor intaadan DROP ku samayn.
-- Haddii auth/django tables hore u jiraan: ha celin qaybta `django_*` / `auth_*`.
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `macalin_guri`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `macalin_guri`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------------------------
-- Django: contenttypes + auth (muhiim: users_user wuxuu u baahan yahay M2M)
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`, `model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`, `codename`),
  KEY `auth_permission_content_type_id_2f476e4b` (`content_type_id`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co`
    FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`, `permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e` (`permission_id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id`
    FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_group_permissions_permission_id_84c5c92e_fk_auth_permission_id`
    FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- users.User (custom — email waa login)
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `users_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `email` varchar(254) NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(32) NULL,
  `role` varchar(20) NOT NULL,
  `profile_image` varchar(512) NOT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `users_user_role_b5f37718` (`role`),
  KEY `users_user_status_0a7b3b2b` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `users_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_user_groups_user_id_group_id_bb60391f_uniq` (`user_id`, `group_id`),
  KEY `users_user_groups_group_id_f11843da_fk_auth_group_id` (`group_id`),
  CONSTRAINT `users_user_groups_user_id_f1749519_fk_users_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`),
  CONSTRAINT `users_user_groups_group_id_f11843da_fk_auth_group_id`
    FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `users_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_user_user_permissions_user_id_permission_id_43338cdf_uniq` (`user_id`, `permission_id`),
  KEY `users_user_user_permissions_permission_id_ce09554e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `users_user_user_permissions_user_id_31782f77_fk_users_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`),
  CONSTRAINT `users_user_user_permissions_permission_id_ce09554e_fk_auth_perm`
    FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `users_devicetoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` varchar(512) NOT NULL,
  `platform` varchar(10) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_device_token` (`user_id`, `token`),
  KEY `users_devicetoken_user_id_fbc86cf7_fk_users_user_id` (`user_id`),
  CONSTRAINT `users_devicetoken_user_id_fbc86cf7_fk_users_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `users_notificationlog` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` varchar(64) NOT NULL,
  `payload_json` json NOT NULL DEFAULT ('{}'),
  `sent_at` datetime(6) NOT NULL,
  `read_at` datetime(6) NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `users_notificationlog_type_da7cb7ad` (`type`),
  KEY `users_notificationlog_user_id_7fbe866a_fk_users_user_id` (`user_id`),
  CONSTRAINT `users_notificationlog_user_id_7fbe866a_fk_users_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- tutoring app
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `tutoring_subject` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tutoring_tutor` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `bio` longtext NOT NULL,
  `experience_years` smallint UNSIGNED NOT NULL,
  `hourly_rate` decimal(10, 2) NOT NULL,
  `rating` decimal(3, 2) NOT NULL,
  `location` varchar(255) NOT NULL,
  `is_verified` tinyint(1) NOT NULL,
  `tutor_status` varchar(20) NOT NULL,
  `rejection_reason` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `tutoring_tutor_tutor_status_bcd88bc8` (`tutor_status`),
  CONSTRAINT `tutoring_tutor_user_id_b04bba08_fk_users_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tutoring_tutorsubject` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `subject_id` bigint NOT NULL,
  `tutor_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_tutor_subject` (`tutor_id`, `subject_id`),
  KEY `tutoring_tutorsubject_subject_id_12f75de7_fk_tutoring_subject_id` (`subject_id`),
  CONSTRAINT `tutoring_tutorsubject_subject_id_12f75de7_fk_tutoring_subject_id`
    FOREIGN KEY (`subject_id`) REFERENCES `tutoring_subject` (`id`),
  CONSTRAINT `tutoring_tutorsubject_tutor_id_da9f54e7_fk_tutoring_tutor_id`
    FOREIGN KEY (`tutor_id`) REFERENCES `tutoring_tutor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tutoring_job` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `location` varchar(255) NOT NULL,
  `salary_or_budget` decimal(12, 2) NOT NULL,
  `schedule_hint` varchar(255) NOT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `publisher_id` bigint NOT NULL,
  `subject_id` bigint NULL,
  PRIMARY KEY (`id`),
  KEY `tutoring_job_status_9beae769` (`status`),
  KEY `tutoring_job_publisher_id_c14dccbb_fk_users_user_id` (`publisher_id`),
  KEY `tutoring_job_subject_id_c80dd84e_fk_tutoring_subject_id` (`subject_id`),
  CONSTRAINT `tutoring_job_publisher_id_c14dccbb_fk_users_user_id`
    FOREIGN KEY (`publisher_id`) REFERENCES `users_user` (`id`),
  CONSTRAINT `fk_job_subject`
    FOREIGN KEY (`subject_id`) REFERENCES `tutoring_subject` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tutoring_jobapplication` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `status` varchar(20) NOT NULL,
  `message` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `job_id` bigint NOT NULL,
  `tutor_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_job_tutor_application` (`job_id`, `tutor_id`),
  KEY `tutoring_jobapplication_status_b22da04f` (`status`),
  KEY `tutoring_jobapplication_job_id_c23ba17e_fk_tutoring_job_id` (`job_id`),
  KEY `tutoring_jobapplication_tutor_id_9dbdbbe7_fk_tutoring_tutor_id` (`tutor_id`),
  CONSTRAINT `tutoring_jobapplication_job_id_c23ba17e_fk_tutoring_job_id`
    FOREIGN KEY (`job_id`) REFERENCES `tutoring_job` (`id`),
  CONSTRAINT `tutoring_jobapplication_tutor_id_9dbdbbe7_fk_tutoring_tutor_id`
    FOREIGN KEY (`tutor_id`) REFERENCES `tutoring_tutor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tutoring_booking` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `session_date` date NOT NULL,
  `start_time` time(6) NOT NULL,
  `end_time` time(6) NOT NULL,
  `session_type` varchar(20) NOT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `parent_user_id` bigint NULL,
  `student_user_id` bigint NULL,
  `subject_id` bigint NOT NULL,
  `tutor_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tutoring_booking_status_eefda9de` (`status`),
  KEY `tutoring_booking_parent_user_id_9beecab8_fk_users_user_id` (`parent_user_id`),
  KEY `tutoring_booking_student_user_id_ecc63609_fk_users_user_id` (`student_user_id`),
  KEY `tutoring_booking_subject_id_c80dd84e_fk_tutoring_subject_id` (`subject_id`),
  KEY `tutoring_booking_tutor_id_da9f54e7_fk_tutoring_tutor_id` (`tutor_id`),
  CONSTRAINT `booking_student_or_parent_required`
    CHECK (`student_user_id` IS NOT NULL OR `parent_user_id` IS NOT NULL),
  CONSTRAINT `fk_booking_parent_user`
    FOREIGN KEY (`parent_user_id`) REFERENCES `users_user` (`id`),
  CONSTRAINT `fk_booking_student_user`
    FOREIGN KEY (`student_user_id`) REFERENCES `users_user` (`id`),
  CONSTRAINT `fk_booking_subject`
    FOREIGN KEY (`subject_id`) REFERENCES `tutoring_subject` (`id`),
  CONSTRAINT `fk_booking_tutor`
    FOREIGN KEY (`tutor_id`) REFERENCES `tutoring_tutor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tutoring_review` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `rating` smallint UNSIGNED NOT NULL,
  `comment` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `student_user_id` bigint NOT NULL,
  `tutor_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tutoring_review_student_user_id_f1749519_fk_users_user_id` (`student_user_id`),
  KEY `tutoring_review_tutor_id_da9f54e7_fk_tutoring_tutor_id` (`tutor_id`),
  CONSTRAINT `tutoring_review_student_user_id_f1749519_fk_users_user_id`
    FOREIGN KEY (`student_user_id`) REFERENCES `users_user` (`id`),
  CONSTRAINT `tutoring_review_tutor_id_da9f54e7_fk_tutoring_tutor_id`
    FOREIGN KEY (`tutor_id`) REFERENCES `tutoring_tutor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tutoring_message` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `body` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `receiver_id` bigint NOT NULL,
  `sender_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tutoring_me_sender__a30537_idx` (`sender_id`, `receiver_id`, `created_at`),
  KEY `tutoring_message_receiver_id_f1749519_fk_users_user_id` (`receiver_id`),
  KEY `tutoring_message_sender_id_f1749519_fk_users_user_id` (`sender_id`),
  CONSTRAINT `tutoring_message_receiver_id_f1749519_fk_users_user_id`
    FOREIGN KEY (`receiver_id`) REFERENCES `users_user` (`id`),
  CONSTRAINT `tutoring_message_sender_id_f1749519_fk_users_user_id`
    FOREIGN KEY (`sender_id`) REFERENCES `users_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- Dhamaad. Kadib: Django `django_migrations` waa inuu muujinayaa in migrations
-- la dhameeyay — isticmaal `python manage.py migrate` si ay u isku xigaan
-- ama `migrate --fake-initial` haddii tables gacanta ay ka hor yimaadaan.
-- =============================================================================
