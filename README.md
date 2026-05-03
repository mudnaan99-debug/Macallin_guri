# Macalin Quri (Macalin Guri / Home Tutors)

App **Flutter** ah oo loogu talagalay **marketplace + booking** macallimiinta guriga (casharro, shaqo-codsiga, ansixinta maamulaha).  

**Qorshaha horumarinta ee la ansixiyay:** backend **Django + Django REST Framework** iyo **MySQL**; **Flutter** wuxuu u adeegsadaa **REST API**. **Firebase Cloud Messaging (FCM)** waxaa loo isticmaali karaa **ogeysiisyada push** marka backend-ku diro (maahan in xogta ku jirto Firebase).

- **System design** (miisaska, API, FCM, UI): [docs/MACALIN_GURI_SYSTEM_DESIGN.md](docs/MACALIN_GURI_SYSTEM_DESIGN.md)  
- **Implementation plan** (marxalado, checklist): [docs/IMPLEMENTATION_PLAN.md](docs/IMPLEMENTATION_PLAN.md)

---

## Isticmaalayaasha (target product)

| Role | Ujeedo |
|------|--------|
| **Student** | Raadinta macallimiinta, booking, reviews |
| **Tutor** | Profile, dalbashada shaqooyinka la publish gareeyay, qabashada ardayda |
| **Parent** | Raadinta macallin caruurta, booking / raaci progress |
| **Publisher** | Publish shaqooyin (jobs) systemka |
| **Admin** | Approve macallimiinta, maamulka codsiyada iyo nidaamka |

Waxaa lagu dhisayaa **hal nidaam oo isku xiran**: macallinka la approve gareeyay wuxuu apply gareeyaa shaqooyinka; ardayga iyo waalidkuna waxay u dalban karaan macallimiinta la ansixiyay.

---

## Architecture (target)

| Qayb | Teknolojiyada |
|------|----------------|
| Mobile / UI | Flutter |
| State | Provider (hadda) — Riverpod waa ikhtiyaar |
| API | REST + JWT |
| Backend | Django + DRF |
| Database | MySQL |
| Push notifications | FCM (token keydin MySQL, push ka Django) |

---

## Shuruudaha horumarinta

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (SDK ^3.8.1 sida `pubspec.yaml`)
- **Horumarinta backend:** Python 3.x, Django, MySQL server
- **FCM (optional):** Firebase project + `google-services.json` Android (iyo iOS haddii loo baahdo)

---

## Socodsiinta app-ka (code-ka hadda jira)

```bash
cd Macllin_guri
flutter pub get
flutter run
```

```bash
flutter build apk
```

**Xusuusin:** code-ka `lib/` wali wuxuu isticmaalaa **Firebase** (Auth, Firestore) ilaa la beddelo API-ga Django. Tilmaamaha isbeddelka: dukumiintiga `docs/MACALIN_GURI_SYSTEM_DESIGN.md` qaybta “Xiriirka code-ka hadda jira”.

### Backend (Django — Phase 0–1) + login API

Mashiinka ku jira folder **[backend/](backend/)**: models, migrations, **JWT** (`/api/auth/token/`, `/api/me/`). Tilmaamaha: **[backend/README.md](backend/README.md)**.

- **Isticmaalayaal tusaale:** `python manage.py create_sample_users` — erayga sirta ah: `Demo123!`
- **Flutter** wuxuu isku xiraa API-ga: faylka `lib/config/api_config.dart` (default Android emulator: `http://10.0.2.2:8000`)
- **HTTP aan SSL lahayn (horumarinta):** Android wuxuu u furtay `usesCleartextTraffic` (debug)

Windows: haddii `python` aanu shaqayn, isticmaal `py -3` (Python launcher).

---

## Qaabka faylasha (`lib/` — hadda)

| Qayb | Ujeedo |
|------|--------|
| `main.dart` | Bilowga app, theme, providers |
| `services/` | `auth_service`, `firestore_service`, `notification_service` → mustaqbalka `api_service` + FCM |
| `models/` | User, Job, Teacher/Tutor, Application, Chat, Notification |
| `screens/` | Auth, dashboards (user / teacher / admin / team it), chat |
| `theme/app_theme.dart` | Midabada — la jaan qaadi kara **seedColor** ka soo baxa logada (`assets/images/logo.jpg`) |

---

## Hantida (assets)

- `assets/images/logo.jpg` — logo; midabada theme-ka waxaa fiican in lagu dhigo ku habboon astaantan.

---

## Liiska shaqooyinka mustaqbalka (high level)

1. ~~Django project + miisaska~~ — skeleton ku yaal `backend/` + migrations (MySQL: ku dar `.env`).
2. JWT auth + endpoints REST.
3. Beddelidda Flutter: HTTP client + models isku eg DB.
4. Register FCM token API + dhagaysi dhacdooyinka (booking, chat, approve, iwm.).
5. UI: Splash → Login → Home (3 cards) → Sign Up → dashboards sida dukumiintiga.

---

**Magaca package:** `macalin_quri` (`pubspec.yaml`).
