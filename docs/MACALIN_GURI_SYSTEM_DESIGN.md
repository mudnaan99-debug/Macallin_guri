# Macalin Guri (Home Tutors) — Analysis & System Design

Dukumiinti habaysan oo loogu talagalay **Flutter + Django REST Framework + MySQL**, oo lagu dhisayo **marketplace + booking** shahaado macallimiinta (Uber-style oo ah waxbarasho).

Marka la dhiso habkan cusub, **Firebase** waxaa loo isticmaali karaa **kaliya FCM** (ogeysiisyada push) haddii aad rabto — xogta iyo auth waxay ku salaysan tahay backend-ka Django.

---

## 1. Fikradda guud (Overview)

### Isticmaalayaasha (roles)

| Role | Somali | Waxa uu sameeyaa |
|------|--------|-------------------|
| **student** | Arday | Raadinta macallimiinta, dalbashada / booking, ra'yiyo |
| **tutor** | Macallin | Profile, dalbashada shaqooyinka soo baxay, qabashada ardayda / waqtiga |
| **parent** | Waalid | Raadinta macallin caruurta, raaci kara habka booking |
| **publisher** (optional) | Isticmaale shaqo dhiga | Wuxuu **publish** karaa shaqooyin (jobs) systemka — sida hore |
| **admin** | Maamulaha | Ansixinta macallimiinta, ansixinta shaqooyinka/codsiyada, maamulka guud |

### Hal dhacdo oo dhameystiran (end-to-end scenario)

1. **Macallin** wuxuu is diiwaangeliyaa → profile macallin (`tutors`) wuxuu noqdaa **pending**.
2. **Admin** wuxuu **approve** gareeyaa macallinka → `is_verified = true` / `status = approved`.
3. **Publisher / User** (ama qof leh xuquuqda) wuxuu **publish** gareeyaa **shaqo** (job) — faahfaahin, waqti, mushahar, meel, iwm.
4. **Macallinka** la ansixiyay wuxuu **apply** gareeyaa** shaqadan (job application).
5. **Arday / Waalid** (student/parent) waxay **apply** gareyn karaan / **booking** ku sameyn karaan **macallimiinta** admin ka ansixiyay (raadinta + xaqiijinta waqtiga).

Tani waxay isku dartaa **shaqo-codsiga** (job marketplace) iyo **booking** (casharka / session-ka).

---

## 2. User flow (App)

```
Splash Screen
    → Login Screen (Email ama Phone + Password)
        → Login | Sign Up
        → “New here? Go to Home” → Home (Doorarka)

Home (Role Selection) — cards qurxoon:
    [ Learn with Experts      ] → student
    [ Become a Tutor          ] → tutor
    [ Find Tutors for Child   ] → parent

Continue → Sign Up (magaca, email, phone, password; role waa mid horay loo doortay)

Gudaha systemka:
    → Dashboard (iyo navigation) iyadoo lagu saleynayo role + ansixinta macallinka
```

**Login kadib:** backend-ku wuxuu soo celinayaa JWT ama token + `user.role` + `tutor.status` (haddii macallin yahay).

---

## 3. Architecture

```
┌─────────────────┐     HTTPS / REST (JSON)     ┌──────────────────────┐
│  Flutter App    │ ◄──────────────────────────► │  Django + DRF        │
│  (Provider /     │                               │  (Auth, Business    │
│   Riverpod)*     │                               │   Logic, Admin)     │
└────────┬────────┘                               └──────────┬───────────┘
         │                                                    │
         │ FCM token registration                             │ ORM
         ▼                                                    ▼
┌─────────────────┐                               ┌──────────────────────┐
│ Firebase (FCM   │                               │ MySQL                │
│  only)*         │                               │ (users, tutors,      │
└─────────────────┘                               │  jobs, bookings…)    │
                                                  └──────────────────────┘
```

\* **State management:** Provider (code-ka hadda) ama Riverpod — doorasho hal mar la go’aamiyo.  
\* **FCM:** Firebase project kaliya FCM; **device token** waxaa keydin karaa MySQL (`device_tokens`).

---

## 4. Database Design (MySQL) — Core Tables

**Xusuusin:** Django ma kaydiyo `password` cad; isticmaal `password` hashed (auth_user ama custom user).

### 4.1 `users`

| Column | Type | Sharaxaad |
|--------|------|-----------|
| id | BIGINT PK AI | |
| name | VARCHAR(255) | |
| email | VARCHAR(255) UNIQUE | |
| phone | VARCHAR(32) UNIQUE NULL | Login alternativ ah |
| password_hash | VARCHAR(255) | Django hashed |
| role | ENUM | `student`, `tutor`, `parent`, `publisher`, `admin` |
| profile_image | VARCHAR(512) NULL | URL ama path |
| status | ENUM | `active`, `blocked` |
| created_at | DATETIME | |

### 4.2 `tutors` (profile macallin — FK → users)

| Column | Type | Sharaxaad |
|--------|------|-----------|
| id | BIGINT PK AI | |
| user_id | BIGINT FK → users.id UNIQUE | Hal user = hal tutor profile |
| bio | TEXT | |
| experience_years | INT | |
| hourly_rate | DECIMAL(10,2) | |
| rating | DECIMAL(3,2) DEFAULT 0 | Celcelis |
| location | VARCHAR(255) | |
| is_verified | BOOLEAN DEFAULT FALSE | Admin approve |
| tutor_status | ENUM | `pending`, `approved`, `rejected` |
| rejection_reason | TEXT NULL | |
| created_at | DATETIME | |

### 4.3 `subjects` & `tutor_subjects`

**subjects:** `id`, `name` (Math, English, …)

**tutor_subjects:** `id`, `tutor_id` FK, `subject_id` FK (many-to-many).

### 4.4 Shaqooyinka & codsiyada (ku darista hore ee app-ka)

**jobs** (shaqo la publish gareeyay)

| Column | Type |
|--------|------|
| id | PK |
| publisher_user_id | FK → users (qofka publish gareeyay) |
| title | VARCHAR |
| description | TEXT |
| subject_id | FK NULL |
| location | VARCHAR |
| salary_or_budget | DECIMAL |
| schedule_hint | VARCHAR |
| status | ENUM: `open`, `closed`, `filled` |
| created_at | DATETIME |

**job_applications** (macallin ku dalbanaya shaqada)

| Column | Type |
|--------|------|
| id | PK |
| job_id | FK |
| tutor_id | FK → tutors |
| status | ENUM: `pending`, `accepted`, `rejected` |
| message | TEXT NULL |
| created_at | DATETIME |

### 4.5 Bookings (arday/waalid ↔ macallin)

**bookings**

| Column | Type |
|--------|------|
| id | PK |
| student_user_id | FK NULL | Arday toos ah |
| parent_user_id | FK NULL | Waalid (mid labadood ama mid) |
| tutor_id | FK |
| subject_id | FK |
| session_date | DATE |
| start_time | TIME |
| end_time | TIME |
| session_type | ENUM | `online`, `physical` |
| status | ENUM | `pending`, `accepted`, `completed`, `cancelled` |
| created_at | DATETIME |

Xeerka ganacsiga: hubi in `student_user_id` ama `parent_user_id` mid ka mid ah uu buuxo.

### 4.6 `reviews`

| id | student_user_id FK | tutor_id FK | rating (1–5) | comment | created_at |

### 4.7 Farriimaha (chat)

**conversations** (optional): `id`, `participant_1`, `participant_2`, `updated_at`

**messages**

| id | conversation_id FK NULL | sender_id FK users | receiver_id FK | body TEXT | created_at |

Ama hab fudud: `sender_id`, `receiver_id`, `body`, `created_at` (index on pair).

### 4.8 FCM / ogeysiisyada

**device_tokens**

| id | user_id FK | token VARCHAR(512) | platform ENUM(`android`,`ios`) | updated_at |

**notification_log** (optional, analytics)

| id | user_id | type | payload_json | sent_at | read_at |

---

## 5. FCM — Analysis (waxa ogeysiis la dirayo)

FCM **ma u baahna** table gaar ah oo “FCM table”; waxaa muhiim ah in **dhacdooyinka** backend-ka ay trigger u noqdaan ogeysiis + keydinta `device_tokens`.

| Dhacdo (event) | Qofka hela | Nooca ogeysiisa (type) |
|----------------|------------|-------------------------|
| Macallin cusub — profile completed | Admin | `tutor_pending_review` |
| Admin approve tutor | Macallin | `tutor_approved` |
| Admin diido tutor | Macallin | `tutor_rejected` |
| Shaqo cusub la publish gareeyay | Macallimiinta la ansixiyay (filter subject/location) | `new_job_posted` |
| Macallin apply job | Publisher | `new_job_application` |
| Publisher accept application | Macallin | `job_application_accepted` |
| Booking cusub | Macallin | `booking_request` |
| Booking la ansixiyay | Arday/Waalid | `booking_confirmed` |
| Farriin chat cusub | Qofka kale | `chat_message` |

**Flow farsamo:** Django signal ama service ka dib `save()`: `send_fcm(user_ids, data_payload)` — payload waa inuu leeyahay `type` si Flutter u kala saaro screenta loo furo.

---

## 6. API Design (REST) — tusaalo

**Auth**

- `POST /api/auth/register/`
- `POST /api/auth/login/` → `{ access, refresh, user }`
- `POST /api/auth/token/refresh/`

**Users & Tutors**

- `GET/PUT /api/me/`
- `POST /api/tutors/register-profile/` (abuur `tutors` + subjects)
- `GET /api/tutors/` — filters: `subject`, `min_price`, `max_price`, `location`, `verified_only=true`
- `GET /api/tutors/{id}/`

**Jobs & applications**

- `GET/POST /api/jobs/`
- `POST /api/jobs/{id}/apply/` (macallin)
- `GET /api/jobs/my-posted/` (publisher)

**Bookings**

- `POST /api/bookings/`
- `GET /api/bookings/` (role-based)

**Reviews**

- `POST /api/reviews/`

**Chat**

- `GET /api/messages/?with_user_id=`
- `POST /api/messages/`

**FCM**

- `POST /api/devices/register-token/` — body: `{ token, platform }`

Dhammaan endpoints-ka waxaa ilaalin kara **JWT** + permissions per role.

---

## 7. UI Screens (Flutter) — liiska horumarinta

1. Splash — logo + loading (midabada hoosta ka eeg qaybta 8).
2. Login — email/phone, password, Login, Sign Up, link Home.
3. Home — 3 cards (Student / Tutor / Parent) + Continue.
4. Sign Up — fields + role auto.
5. Dashboards: Tutor / Student / Parent / Admin / Publisher (haddii la kala saaro).
6. Tutor listing — filters + cards (magaca, rating, qiimo, Book).
7. Booking — waqti + xaqiijin.
8. Chat — real-time (WebSocket ama polling + FCM push).

---

## 8. UI Design & Colors (qurxoon, la jaan qaada astaanta)

### Habka loo xulo midabada

1. **Ka soo saar** midabada asalka ah ee `assets/images/logo.jpg` (widget ama design tool) — **Primary** iyo **Accent**.
2. Haddii aan la helin wax sax ah: **Blue** (waxbarasho), **Green** (kalsooni), **White / off-white** (nadiif) — sida aad sheegtay.
3. **Gradient** fudud oo ka socota Primary → Accent ee buttons iyo header-yada.
4. **Card + elevation** + **radius** isku mid ah (tusaale 12–16px).
5. **Dark mode:** isku midabyo ah oo qoto dheer (navy / charcoal) si ay u la jaan qaadaan astaanta.

### Theme Flutter (tusaale fikrad)

- `ColorScheme.fromSeed(seedColor: Color(...))` — seed waa mid ka mid ah midabada logada.
- `ThemeData` hal meel: `lib/theme/app_theme.dart` — isbeddel hal mar.

### Iconography

- Material Icons / Font Awesome — isku qaab (outline ama filled hal app oo dhan).

---

## 9. Tech flow (buuxa)

```
Flutter  →  REST (JSON + JWT)  →  Django/DRF  →  MySQL
   ↓
Device token → POST /api/devices/register-token/
   ↓
Backend marka dhacdo dhacdo  →  FCM HTTP v1  →  Taleefanka
```

---

## 10. Business model (fikir dambe)

- Commission bo booking (tusaale 10%).
- Subscription macallimiinta (premium listing).
- Premium placement raadinta.

---

## 11. Xiriirka code-ka hadda jira (Firebase)

Code-ka root-ka (`firebase_*`, Firestore) waa **habka hore**. Qorshaha cusub waa:

1. Abuur Django project + MySQL + miisaska kor ku xusan.
2. Ku beddel `AuthService` / `FirestoreService` → `ApiService` (dio/http) + models isku mid ah qaabka DB.
3. Firebase **kaliya** `google-services.json` + FCM haddii aad sii wadato ogeysiisyada.

README-gu wuxuu tilmaami doonaa qaabkan cusub; khariidad faahfaahsan waa dukumiintigan.

---

**La sameeyay:** design document — ma aha inuu si toos ah u beddelo dhammaan code-ka ilaa la hirgeliyo Django backend.

**Hirgelinta (tallaabo talaabo):** [IMPLEMENTATION_PLAN.md](./IMPLEMENTATION_PLAN.md)
