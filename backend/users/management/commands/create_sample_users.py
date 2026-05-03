"""
Sample users for login testing — password for all: Demo123!

Run: python manage.py create_sample_users

SQL isku mid ah (phpMyAdmin): backend/sql/insert_sample_users.sql
"""
from django.core.management.base import BaseCommand
from django.db import transaction

from tutoring.models import Tutor
from users.models import User

SAMPLE_PASSWORD = "Demo123!"

SAMPLES = [
    {
        "email": "admin@sample.macalin",
        "name": "Admin Kaabis",
        "role": User.Role.ADMIN,
        "staff": True,
        "superuser": False,
    },
    {
        "email": "student@sample.macalin",
        "name": "Arday Tusaale",
        "role": User.Role.STUDENT,
    },
    {
        "email": "tutor@sample.macalin",
        "name": "Macallin Tusaale",
        "role": User.Role.TUTOR,
        "make_tutor_profile": True,
    },
    {
        "email": "parent@sample.macalin",
        "name": "Waalid Tusaale",
        "role": User.Role.PARENT,
    },
    {
        "email": "publisher@sample.macalin",
        "name": "Publisher Tusaale",
        "role": User.Role.PUBLISHER,
    },
    {
        "email": "demo@sample.macalin",
        "name": "Demo Isticmaale",
        "role": User.Role.STUDENT,
    },
]


class Command(BaseCommand):
    help = "Creates sample users (password: Demo123!) for Flutter/API testing."

    @transaction.atomic
    def handle(self, *args, **options):
        created_n = 0
        for row in SAMPLES:
            email = row["email"]
            user, created = User.objects.get_or_create(
                email=email,
                defaults={
                    "name": row["name"],
                    "role": row["role"],
                    "is_staff": row.get("staff", False),
                    "is_superuser": row.get("superuser", False),
                },
            )
            if created:
                user.set_password(SAMPLE_PASSWORD)
                user.save()
                created_n += 1
                self.stdout.write(self.style.SUCCESS(f"Created {email}"))
            else:
                user.set_password(SAMPLE_PASSWORD)
                user.name = row["name"]
                user.role = row["role"]
                user.is_staff = row.get("staff", False)
                user.save()
                self.stdout.write(self.style.WARNING(f"Updated password & fields for {email}"))

            if row.get("make_tutor_profile"):
                tutor, t_created = Tutor.objects.get_or_create(
                    user=user,
                    defaults={
                        "bio": "Profile tusaale — Django backend.",
                        "experience_years": 3,
                        "hourly_rate": 25,
                        "location": "Mogadishu",
                        "is_verified": True,
                        "tutor_status": Tutor.TutorStatus.APPROVED,
                    },
                )
                if t_created:
                    self.stdout.write(self.style.SUCCESS(f"  + Tutor profile for {email}"))
                else:
                    tutor.is_verified = True
                    tutor.tutor_status = Tutor.TutorStatus.APPROVED
                    tutor.save()

        self.stdout.write("")
        self.stdout.write(self.style.SUCCESS(f"Done. Password for all sample accounts: {SAMPLE_PASSWORD}"))
