# Macalin Guri API — CodeIgniter 4

Isla jidadka hore ee Flutter (`SessionController`):

| Method | Path | Sharaxaad |
|--------|------|-----------|
| GET | `/api/health/` | JSON `status`, `service` |
| POST | `/api/auth/token/` | Body `{"email","password"}` → `access`, `refresh` |
| POST | `/api/auth/token/refresh/` | Body `{"refresh"}` → tokens cusub |
| POST | `/api/auth/register/` | Body `email`, `password`, `name`, `phone?`, `role?` |
| GET | `/api/me/` | Header `Authorization: Bearer <access>` |

## Rakibid

1. PHP: fur `php.ini` (XAMPP) → `extension=intl` (CI4 wuxuu u baahan yahay).
2. `cd backend_ci4`
3. `copy env.macalin .env` ama ku dar faylka `.env` (tusaale hoos).
4. `composer install` (haddii intl la damiyo; haddii kale: `composer install --ignore-platform-req=ext-intl`)
5. Miiska MySQL `macalin_guri` + `users_user` (sida `sql/macalin_guri_full_schema.sql` ee xididka mashruuca).
6. Ordo server:
   ```bash
   php spark serve --host 0.0.0.0 --port 8080
   ```
   ama Apache **DocumentRoot** → `backend_ci4/public`

## `.env` (muhiim)

```
CI_ENVIRONMENT = development

database.default.hostname = 127.0.0.1
database.default.database = macalin_guri
database.default.username = root
database.default.password =
database.default.DBDriver = MySQLi
database.default.port = 3306

jwt.secret = beddel-64-xaraf-oo-dheer-oo-gaar-ah-horumar
jwt.accessTtl = 3600
jwt.refreshTtl = 604800
```

`jwt.secret` waa inuu ahaadaa string adag (HS256).

## Flutter

`ApiConfig.baseUrl` → URL-ga CI4 (Apache `public` ama `php spark serve`).

## Password (`users_user`)

Waxaa lagu kaydiyaa `pbkdf2_sha256$...` — abuur / hubin: `App\Libraries\Pbkdf2PasswordHasher`.
