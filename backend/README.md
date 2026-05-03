# Macalin Guri — Django API (Phase 0–1)

## Rakibida

```bash
cd backend
python -m venv .venv
# Windows:
.venv\Scripts\activate
# macOS/Linux:
# source .venv/bin/activate

pip install -r requirements.txt
```

### Database

- **Horumarinta degdeg ah (SQLite):** ha dhigin `DATABASE_NAME` — `config/settings.py` wuxuu isticmaalayaa `db.sqlite3`.
- **MySQL:** abuur database `macalin_guri` (utf8mb4), ka dibna nuqul `.env.example` → `.env` oo buuxi `DATABASE_NAME`, `DATABASE_USER`, `DATABASE_PASSWORD`, iwm.

```bash
copy .env.example .env
# Edit .env — set DATABASE_* for MySQL
```

### Migrations

```bash
python manage.py makemigrations users tutoring
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

### Isticmaalayaasha tusaale (login Flutter)

```bash
python manage.py create_sample_users
```

**Password wadaag:** `Demo123!`

| Email | Role |
|-------|------|
| `admin@sample.macalin` | admin |
| `student@sample.macalin` | student |
| `tutor@sample.macalin` | tutor (profile la ansixiyay) |
| `parent@sample.macalin` | parent |
| `publisher@sample.macalin` | publisher |
| `demo@sample.macalin` | student (demo guud) |

### API (REST)

- `GET /api/health/`
- `POST /api/auth/token/` — body: `{"username": "EMAIL", "password": "..."}` (SimpleJWT isticmaalaa `username` key, laakiin qiimuhu waa **email**)
- `POST /api/auth/token/refresh/`
- `POST /api/auth/register/`
- `GET /api/me/` — `Authorization: Bearer <access>`

**Flutter** (emulator): `http://10.0.2.2:8000` — fayl `lib/config/api_config.dart` / `--dart-define=API_BASE_URL=...`

Admin: http://127.0.0.1:8000/admin/

## Qaabka project-ka

| App | Waxa ku jira |
|-----|----------------|
| `users` | `User` (custom), `DeviceToken`, `NotificationLog` |
| `tutoring` | `Subject`, `Tutor`, `TutorSubject`, `Job`, `JobApplication`, `Booking`, `Review`, `Message` |

Tixraac design: [../docs/MACALIN_GURI_SYSTEM_DESIGN.md](../docs/MACALIN_GURI_SYSTEM_DESIGN.md)

### MySQL — SQL gacanta (phpMyAdmin)

- Tilmaamo: [sql/00_README.md](sql/00_README.md)
- Database kaliya: [sql/01_create_database.sql](sql/01_create_database.sql)
- Miisaska oo dhan (hal mar): [sql/macalin_guri_full_schema.sql](sql/macalin_guri_full_schema.sql)
- **Isticmaalayaasha tusaale (INSERT):** [sql/insert_sample_users.sql](sql/insert_sample_users.sql) — password `Demo123!` (sida `create_sample_users`)

## Xiga (Phase 2+)

REST endpoints (JWT), serializers, iyo xiriirka Flutter — sida [../docs/IMPLEMENTATION_PLAN.md](../docs/IMPLEMENTATION_PLAN.md).
