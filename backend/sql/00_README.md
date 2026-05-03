# MySQL — SQL gacanta (phpMyAdmin / copy-paste)

## Laba hab

### A) Ugu wanaagsan (Django wuxuu abuuraa auth + jadwalka)
1. Samee database: `CREATE DATABASE macalin_guri ...` (ama isticmaal faylka `01_create_database.sql`).
2. Ku dheji `.env` MySQL credentials.
3. `python manage.py migrate`

### Isticmaalayaasha tusaale (SQL kaliya)

Fayl: **`insert_sample_users.sql`** — `INSERT` + `ON DUPLICATE KEY UPDATE` (password: **Demo123!**, hash Django 5.2).

### B) Hal mar oo sql oo keliya (PHPMyAdmin)
1. Fur **SQL** tab phpMyAdmin.
2. Ku dheji waxa ku jira **`macalin_guri_full_schema.sql`** (hal mar) — ama u kala jar qaybo haddii server-ku xaddido cabbirka query-ga.

**Xusuusin:** Faylka `macalin_guri_full_schema.sql` wuxuu ku darayaa miisaska **Django auth / contenttypes** (yar) si `users_user` ugu shaqeeyo **groups** iyo **permissions**. Haddii auth tables hormarka ah ku jiraan, ka fogow inaad ku celiso qaybta `django_*` / `auth_*` ama isticmaal `migrate` (habka A).

## Magacyada miisaska (Django default)

| Table | App |
|-------|-----|
| `users_user` | User |
| `users_user_groups` | M2M |
| `users_user_user_permissions` | M2M |
| `users_devicetoken` | FCM |
| `users_notificationlog` | Ogeysiis |
| `tutoring_*` | Shaqo, macallin, booking, iwm. |

## Kadib markaad SQL gacanta ku dhisto

1. Isku xidh `.env` MySQL ( `DATABASE_NAME=macalin_guri` , iwm.).
2. **Django wuxuu u baahan yahay** in `django_migrations` uu ogaado in miisaska la abuuray: `python manage.py migrate --fake-initial` (haddii khalad, `showmigrations` / `sqlmigrate` la socda).
3. Haddii `payload_json` `DEFAULT` uu khalad MySQL yahay, `macalin_guri_full_schema.sql` column-ka `users_notificationlog.payload_json` ka saar `DEFAULT` ama u beddel `NULL`.

## Saaxiibka MySQL / phpMyAdmin

1. Login phpMyAdmin → **SQL** tab.
2. Ku dheji nuxurka `macalin_guri_full_schema.sql` (ama u kala qaybi 2–3 qaybood haddii xadid).
3. **Go** / **Run**.
4. **Structure** → hubi in `users_user`, `tutoring_job`, iwm. ay muuqdaan.
