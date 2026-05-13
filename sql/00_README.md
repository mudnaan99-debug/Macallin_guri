# MySQL — SQL gacanta (phpMyAdmin / copy-paste)

## Laba hab

### A) Ugu wanaagsan (phpMyAdmin / MySQL)
1. Samee database: `CREATE DATABASE macalin_guri ...` (ama isticmaal faylka `01_create_database.sql`).
2. Ku dheji `macalin_guri_full_schema.sql` (hal mar ama qaybo) si `users_user` iyo miisaska la xidhiidha ay u dhacaan.
3. Ku dheji `backend_ci4/.env` MySQL credentials (CI4 API).

### Isticmaalayaasha tusaale (SQL kaliya)

Fayl: **`insert_sample_users.sql`** — `INSERT` + `ON DUPLICATE KEY UPDATE` (password: **Demo123!**, hash `pbkdf2_sha256` sida `backend_ci4` `Pbkdf2PasswordHasher`).

### B) Hal mar oo sql oo keliya (PHPMyAdmin)
1. Fur **SQL** tab phpMyAdmin.
2. Ku dheji waxa ku jira **`macalin_guri_full_schema.sql`** (hal mar) — ama u kala jar qaybo haddii server-ku xaddido cabbirka query-ga.

**Xusuusin:** `macalin_guri_full_schema.sql` wuxuu ku darayaa miisaska **auth + content types** (magacyada `django_*` / `auth_*` waa qaabka asalka DB-ga) si `users_user` ugu shaqeeyo **groups** iyo **permissions**. Haddii miisaskan hore u jiraan, ha celin qaybta soo celinta.

## Magacyada miisaska (auth + app)

| Table | App |
|-------|-----|
| `users_user` | User |
| `users_user_groups` | M2M |
| `users_user_user_permissions` | M2M |
| `users_devicetoken` | FCM |
| `users_notificationlog` | Ogeysiis |
| `tutoring_*` | Shaqo, macallin, booking, iwm. |

## Kadib markaad SQL gacanta ku dhisto

1. Isku xidh `backend_ci4/.env` MySQL (`database.default.database=macalin_guri`, iwm.).
2. Ordo API: `cd backend_ci4` → `php spark serve --host 0.0.0.0 --port 8080`.
3. Haddii `payload_json` `DEFAULT` uu khalad MySQL yahay, `macalin_guri_full_schema.sql` column-ka `users_notificationlog.payload_json` ka saar `DEFAULT` ama u beddel `NULL`.

## Saaxiibka MySQL / phpMyAdmin

1. Login phpMyAdmin → **SQL** tab.
2. Ku dheji nuxurka `macalin_guri_full_schema.sql` (ama u kala qaybi 2–3 qaybood haddii xadid).
3. **Go** / **Run**.
4. **Structure** → hubi in `users_user`, `tutoring_job`, iwm. ay muuqdaan.
