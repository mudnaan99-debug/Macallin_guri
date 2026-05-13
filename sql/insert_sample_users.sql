-- =============================================================================
-- Isticmaalayaasha tusaale — SQL (phpMyAdmin / MySQL)
-- Password wadaag: Demo123!  (hash: pbkdf2_sha256, 1_000_000 iterations — `Pbkdf2PasswordHasher` CI4)
-- =============================================================================
-- Hubi: miisaska `users_user` iyo `tutoring_tutor` hore u jiraan (macalin_guri_full_schema.sql).
-- Haddii email hore u jirto: ON DUPLICATE KEY UPDATE wuxuu cusboonaysiinayaa magaca, role, password.
-- =============================================================================

USE `macalin_guri`;

SET @pw := 'pbkdf2_sha256$1000000$AbCdEfGhIjKlMnOpQrStUv$cYkp916j4rdYqIctd+I31e9AqAQ9YTcLVTkK0SnPBhg=';

INSERT INTO `users_user` (
  `password`, `last_login`, `is_superuser`, `first_name`, `last_name`, `is_staff`, `is_active`, `date_joined`,
  `email`, `name`, `phone`, `role`, `profile_image`, `status`, `created_at`
) VALUES (
  @pw, NULL, 0, '', '', 1, 1, NOW(6),
  'admin@sample.macalin', 'Admin Kaabis', NULL, 'admin', '', 'active', NOW(6)
) ON DUPLICATE KEY UPDATE
  `password` = VALUES(`password`), `name` = VALUES(`name`), `role` = VALUES(`role`),
  `is_staff` = VALUES(`is_staff`), `is_superuser` = VALUES(`is_superuser`);

INSERT INTO `users_user` (
  `password`, `last_login`, `is_superuser`, `first_name`, `last_name`, `is_staff`, `is_active`, `date_joined`,
  `email`, `name`, `phone`, `role`, `profile_image`, `status`, `created_at`
) VALUES (
  @pw, NULL, 0, '', '', 0, 1, NOW(6),
  'student@sample.macalin', 'Arday Tusaale', NULL, 'student', '', 'active', NOW(6)
) ON DUPLICATE KEY UPDATE
  `password` = VALUES(`password`), `name` = VALUES(`name`), `role` = VALUES(`role`);

INSERT INTO `users_user` (
  `password`, `last_login`, `is_superuser`, `first_name`, `last_name`, `is_staff`, `is_active`, `date_joined`,
  `email`, `name`, `phone`, `role`, `profile_image`, `status`, `created_at`
) VALUES (
  @pw, NULL, 0, '', '', 0, 1, NOW(6),
  'tutor@sample.macalin', 'Macallin Tusaale', NULL, 'tutor', '', 'active', NOW(6)
) ON DUPLICATE KEY UPDATE
  `password` = VALUES(`password`), `name` = VALUES(`name`), `role` = VALUES(`role`);

INSERT INTO `users_user` (
  `password`, `last_login`, `is_superuser`, `first_name`, `last_name`, `is_staff`, `is_active`, `date_joined`,
  `email`, `name`, `phone`, `role`, `profile_image`, `status`, `created_at`
) VALUES (
  @pw, NULL, 0, '', '', 0, 1, NOW(6),
  'parent@sample.macalin', 'Waalid Tusaale', NULL, 'parent', '', 'active', NOW(6)
) ON DUPLICATE KEY UPDATE
  `password` = VALUES(`password`), `name` = VALUES(`name`), `role` = VALUES(`role`);

INSERT INTO `users_user` (
  `password`, `last_login`, `is_superuser`, `first_name`, `last_name`, `is_staff`, `is_active`, `date_joined`,
  `email`, `name`, `phone`, `role`, `profile_image`, `status`, `created_at`
) VALUES (
  @pw, NULL, 0, '', '', 0, 1, NOW(6),
  'publisher@sample.macalin', 'Publisher Tusaale', NULL, 'publisher', '', 'active', NOW(6)
) ON DUPLICATE KEY UPDATE
  `password` = VALUES(`password`), `name` = VALUES(`name`), `role` = VALUES(`role`);

INSERT INTO `users_user` (
  `password`, `last_login`, `is_superuser`, `first_name`, `last_name`, `is_staff`, `is_active`, `date_joined`,
  `email`, `name`, `phone`, `role`, `profile_image`, `status`, `created_at`
) VALUES (
  @pw, NULL, 0, '', '', 0, 1, NOW(6),
  'demo@sample.macalin', 'Demo Isticmaale', NULL, 'student', '', 'active', NOW(6)
) ON DUPLICATE KEY UPDATE
  `password` = VALUES(`password`), `name` = VALUES(`name`), `role` = VALUES(`role`);

-- Team IT (login: teamit@gmail.com / teamit123) — `role` waa `teamIt` si Flutter `HomeWrapper` u aqoonsado.
SET @pw_teamit := 'pbkdf2_sha256$1000000$afrLqW2lzN38BdYwqT4aTJ$qsyICCaDL6S6y32WtLmmvJz9/06trqeNQM0ffWXqvqs=';

INSERT INTO `users_user` (
  `password`, `last_login`, `is_superuser`, `first_name`, `last_name`, `is_staff`, `is_active`, `date_joined`,
  `email`, `name`, `phone`, `role`, `profile_image`, `status`, `created_at`
) VALUES (
  @pw_teamit, NULL, 0, '', '', 0, 1, NOW(6),
  'teamit@gmail.com', 'Team IT', NULL, 'teamIt', '', 'active', NOW(6)
) ON DUPLICATE KEY UPDATE
  `password` = VALUES(`password`), `name` = VALUES(`name`), `role` = VALUES(`role`);

-- Profile macallin (tutor@sample.macalin) — la ansixiyay
INSERT INTO `tutoring_tutor` (
  `bio`, `experience_years`, `hourly_rate`, `rating`, `location`, `is_verified`, `tutor_status`,
  `rejection_reason`, `created_at`, `user_id`
)
SELECT
  'Profile tusaale — SQL insert.',
  3,
  25.00,
  0.00,
  'Mogadishu',
  1,
  'approved',
  '',
  NOW(6),
  `id`
FROM `users_user`
WHERE `email` = 'tutor@sample.macalin'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `is_verified` = 1,
  `tutor_status` = 'approved';
