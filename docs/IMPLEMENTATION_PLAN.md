# Macalin Guri — Implementation Plan

Qorshahan waxaa lagu saleynayaa **[MACALIN_GURI_SYSTEM_DESIGN.md](./MACALIN_GURI_SYSTEM_DESIGN.md)** (architecture, miisaska MySQL, API, FCM). Ujeedadu waa **hal hal tallaabo oo la hubiyo** hirgelinta Flutter + Django + MySQL + FCM.

---

## 1. Go’aaminta hora (la xalli kara hal sprint ka hor)

| Arrin | Doorasho la talinayo |
|--------|----------------------|
| Custom User vs default Django User | **AbstractBaseUser** ama **AUTH_USER_MODEL** custom oo leh `role`, `phone`, `profile_image` si ay DB-gu u dhigmaato miiska design-ka |
| JWT | **djangorestframework-simplejwt** — access + refresh |
| File uploads | **MEDIA** backend + URL ku soo celinta Flutter (profile images); production: S3/compatible ikhtiyaar |
| Real-time chat | **Phase 1:** REST polling ama refresh; **Phase 2:** Django Channels/WebSocket ama third-party |
| FCM from Django | **Firebase Admin SDK** (HTTP v1) ama google-auth + FCM REST — token keydin `device_tokens` |
| Flutter HTTP | **dio** ama `http` + interceptors JWT |
| State | **Sii wad Provider** ilaa API layer la dhammeeyo; Riverpod waa refactor dambe |

Go’aaminta kor ku xusan **hoos u dhigaan** beddelka code-ka badan.

---

## 2. Marxaladaha guud (overview)

| Phase | Magaca | Hadafka |
|-------|--------|---------|
| **0** | Repos & environment | Repo backend, MySQL, `.env`, CI fudud |
| **1** | Django core & DB | Models, migrations, admin, User + Tutor + … |
| **2** | Auth & permissions | Register/login/JWT, role-based permissions |
| **3** | Domain APIs | Jobs, applications, bookings, reviews, messages |
| **4** | FCM & events | `device_tokens`, signals → push |
| **5** | Flutter API layer | `ApiClient`, models, replace Firebase services |
| **6** | Flutter UI/UX | Splash → Home cards → Sign up flow, dashboards |
| **7** | QA & hardening | Tests, rate limits, logging, release |

Phases 5–6 waxay ku xiran yihiin marka Phase 2–3 ay si fiican u shaqeeyaan (minimum: auth + list tutors + one booking flow).

---

## 3. Phase 0 — Repos & environment

**Hadafka:** backend la dhiso meel la socodsiyo.

| # | Tallaabo | Heshiis / xog |
|---|----------|----------------|
| 0.1 | Abuur folder `backend/` (ama repo gaar ah) | `django-admin startproject` |
| 0.2 | Ku dar `requirements.txt`: Django, djangorestframework, djangorestframework-simplejwt, mysqlclient (ama PyMySQL), django-cors-headers, Pillow | La jaan qaado versions |
| 0.3 | Abuur database MySQL oo ku magac dar ah project-ka | User/password localhost |
| 0.4 | `.env`: `SECRET_KEY`, `DEBUG`, `DATABASE_URL` ama vars gaar ah | **Ku dar `.gitignore`** |
| 0.5 | `CORS_ALLOWED_ORIGINS` development (Flutter web/emulator) | |
| 0.6 | `README` backend: sida loo rakibo `pip install`, `migrate`, `runserver` | |

**La dhammeeyay marka:** `python manage.py migrate` oo aan khalad lahayn; server bilaabmay.

---

## 4. Phase 1 — Django models & Admin

**Hadafka:** miisaska design-ka oo ORM ah + Admin si loo tijaabiyo xog.

| # | Tallaabo | La hubiyo |
|---|----------|-----------|
| 1.1 | Model **User** (custom) — fields: name, email, phone, role, profile_image, status | Unique email/phone sida design |
| 1.2 | **Tutor** → OneToOne ama FK User | `tutor_status`, `is_verified`, `rejection_reason` |
| 1.3 | **Subject**, **TutorSubject** (M2M through) | |
| 1.4 | **Job**, **JobApplication** | FK Publisher → User |
| 1.5 | **Booking** — constraint: `(student_user_id XOR parent_user_id)` server-side ama `clean()` | |
| 1.6 | **Review**, **Message** (ama Conversation + Message) | Indexes on FK + created_at |
| 1.7 | **DeviceToken** | Unique `(user, token)` ama update token |
| 1.8 | **django-admin** register models muhiimka ah | |

**La dhammeeyay marka:** migrations oo aan lumin data sample; admin ka dhigi kara User/Tutor/Job.

---

## 5. Phase 2 — Authentication & RBAC

**Hadafka:** REST login/register + JWT + xaddidaadda doorarka.

| # | Tallaabo | Faahfaahin |
|---|----------|------------|
| 2.1 | `POST /api/auth/register/` — fields + `role` (student/tutor/parent/publisher) | Ha siin admin publicly |
| 2.2 | `POST /api/auth/login/` — email ama phone + password | Token + user serializer |
| 2.3 | SimpleJWT: access/refresh, rotation optional | |
| 2.4 | **Permissions:** IsAdminUser, IsTutorApproved, IsPublisher, … ama custom permission classes | |
| 2.5 | `GET/PATCH /api/me/` | Profile update |
| 2.6 | Rate limit auth endpoints (optional: django-ratelimit) | |

**La dhammeeyay marka:** Postman/curl login → 200 + JWT; non-admin ma heli karo admin endpoints.

---

## 6. Phase 3 — Domain REST APIs

**Hadafka:** dhammaan flows-ka ganacsiga ee design-ka.

**Tutors**

| Endpoint | Ujeedo |
|----------|--------|
| `POST /api/tutors/register-profile/` | Abuur Tutor `pending` + subjects |
| `GET /api/tutors/` | Filters: subject, price, location, `verified_only` |
| `GET /api/tutors/{id}/` | Detail |
| Admin actions | `PATCH` approve/reject tutor (internal/admin API) |

**Jobs**

| Endpoint | Ujeedo |
|----------|--------|
| `GET/POST /api/jobs/` | Publisher POST; GET list |
| `POST /api/jobs/{id}/apply/` | Tutor approved only |
| `GET /api/jobs/my-posted/` | Publisher |

**Bookings & reviews**

| Endpoint | Ujeedo |
|----------|--------|
| `POST /api/bookings/` | Student/parent → tutor |
| `GET /api/bookings/` | Role-filtered lists |
| `POST /api/reviews/` | After completed session (xidhiidh business rule) |

**Messages**

| Endpoint | Ujeedo |
|----------|--------|
| `GET /api/messages/` | Query `with_user_id` |
| `POST /api/messages/` | Send |

**La dhammeeyay marka:** scenario guud (tutor pending → admin approve → job → apply → booking) oo lagu dhammeeyo API kaliya (Postman collection).

---

## 7. Phase 4 — FCM integration

| # | Tallaabo |
|---|----------|
| 4.1 | Firebase service account JSON server-side (`.env` path, **gitignore**) |
| 4.2 | `POST /api/devices/register-token/` — save/update DeviceToken |
| 4.3 | Utility `send_push(user_ids, title, body, data={type: ...})` |
| 4.4 | Django signals ama service calls ka dib: tutor submitted, approved, job posted, application, booking, message |
| 4.5 | Optional: **notification_log** table + mark read endpoint |

**La dhammeeyay marka:** hal dhacdo (tusaale booking created) oo taleefanka ku muuqda notification (dev build).

---

## 8. Phase 5 — Flutter: API layer

**Hadafka:** ka saarida ku tiirsanaanta Firestore/Auth xogta ganacsiga (FCM wuu sii jiri karaa).

| # | Tallaabo |
|---|----------|
| 5.1 | Ku dar `dio` (ama http) + `flutter_secure_storage` JWT |
| 5.2 | `.env` / `--dart-define` base URL API |
| 5.3 | `lib/services/api_client.dart` — interceptors (Authorization header, 401 → refresh) |
| 5.4 | Models JSONSerializable ama `fromJson` isku mid ah backend serializers |
| 5.5 | `AuthApi`, `TutorApi`, `JobsApi`, `BookingsApi`, … ama hal repository pattern |
| 5.6 | Beddel `AuthService`: login/register/signOut → API |
| 5.7 | Beddel `FirestoreService` → REST calls (incremental: hal feature hal mar) |

**Istaraatiijiyad hal-abuur:** **feature flags** ama `USE_REST_API` si aad u test Firebase side-by-side ilaa la beddelo.

**La dhammeeyay marka:** login + hal CRUD flow oo REST ah oo shaqeeya.

---

## 9. Phase 6 — Flutter UI (design doc §2, §7, §8)

| # | Tallaabo |
|---|----------|
| 6.1 | Splash + theme midabyo ka soo baxa logo (`ColorScheme.fromSeed` / gradient) |
| 6.2 | Login + link “Go to Home” |
| 6.3 | **Home role selection** — 3 cards (Student / Tutor / Parent) |
| 6.4 | Sign up — role auto-filled |
| 6.5 | Routing guud: marka `role` + `tutor_status` ay kala duwan yihiin dashboards |
| 6.6 | Tutor listing + filters + booking screen |
| 6.7 | Chat UI REST (polling interval ama pull-to-refresh) ilaa WebSocket la helo |

**La dhammeeyay marka:** UI flow UX design + APIs isku xiran.

---

## 10. Phase 7 — QA, security, release

| # | Tallaabo |
|---|----------|
| 7.1 | Django: `ALLOWED_HOSTS`, HTTPS production, security middleware |
| 7.2 | Validate inputs (serializers), pagination (`page`, `page_size`) |
| 7.3 | pytest / APITestCase critical paths |
| 7.4 | Flutter widget/integration tests authentication flow |
| 7.5 | Build release APK/App Bundle + backend deploy checklist |

---

## 11. Xiriirka miiska scenarios & APIs

Halkan waxaa lagu xaqiijinayaa in implementation-ku **dhamaan** scenario-ga design:

| Scenario | API / backend checks |
|----------|---------------------|
| Macallin signup | Register `role=tutor` + `POST tutors/register-profile` → `pending` |
| Admin approve | Admin-only PATCH tutor → `approved`, `is_verified=True` |
| Publisher job | `POST /jobs/` |
| Tutor apply | `POST /jobs/{id}/apply/`, tutor must be approved |
| Arday/waalid booking | `POST /bookings/`, tutor approved + verified_only list |

---

## 12. Data migration (Firebase → MySQL) — ikhtiyaar

Haddii xog hore Firestore ku jirto:

1. Export CSV ama script Firestore → JSON.
2. Script Python `manage.py` custom command: import Users (password reset email users!), Tutors, Jobs flat.
3. **Ha soo keydin password** — email users “reset password”.

Haddii **greenfield**: ma jiro migration.

---

## 13. Heerarka la dhammeeyo (Definition of Done)

- **Milestone M1:** Backend auth + Tutor list (`verified_only`) + hal booking POST.
- **Milestone M2:** Jobs + applications dhamaan + admin approve tutor.
- **Milestone M3:** Flutter app REST-only for core flows + FCM on key events.
- **Milestone M4:** Release candidate (tests + prod config).

---

## 14. Liiska hubinta (checklist) — copy/paste progress

```
Phase 0  [ ] env + MySQL + CORS
Phase 1  [ ] models + migrations + admin
Phase 2  [ ] JWT + register/login + /me + permissions
Phase 3  [ ] tutors + jobs + applications + bookings + reviews + messages
Phase 4  [ ] FCM register token + send on events
Phase 5  [ ] Flutter ApiClient + replace auth/data layer
Phase 6  [ ] Splash, Home cards, signup, dashboards, booking UI
Phase 7  [ ] tests + production hardening + release build
```

---

## 15. Tixraacyada

- Design buuxa: [MACALIN_GURI_SYSTEM_DESIGN.md](./MACALIN_GURI_SYSTEM_DESIGN.md)
- Entry README: [../README.md](../README.md)

---

**Cusboonaysiinta:** marka phase la dhammeeyo, ku calaamadee checkbox-yada qaybta 14 — si kooxda / mustaqbalka loo socdo horumarka.
