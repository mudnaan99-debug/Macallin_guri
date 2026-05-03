from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    """Custom user — email login; roles per MACALIN_GURI_SYSTEM_DESIGN."""

    username = None
    email = models.EmailField("email address", unique=True)
    name = models.CharField(max_length=255)
    phone = models.CharField(max_length=32, unique=True, null=True, blank=True)

    class Role(models.TextChoices):
        STUDENT = "student", "Student"
        TUTOR = "tutor", "Tutor"
        PARENT = "parent", "Parent"
        PUBLISHER = "publisher", "Publisher"
        ADMIN = "admin", "Admin"

    role = models.CharField(
        max_length=20,
        choices=Role.choices,
        default=Role.STUDENT,
        db_index=True,
    )
    profile_image = models.CharField(
        max_length=512,
        blank=True,
        default="",
        help_text="URL or relative path to stored image.",
    )

    class Status(models.TextChoices):
        ACTIVE = "active", "Active"
        BLOCKED = "blocked", "Blocked"

    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.ACTIVE,
        db_index=True,
    )
    created_at = models.DateTimeField(auto_now_add=True)

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["name"]

    class Meta:
        ordering = ["-created_at"]

    def __str__(self) -> str:
        return f"{self.name} <{self.email}>"


class DeviceToken(models.Model):
    """FCM device tokens (design §4.8)."""

    class Platform(models.TextChoices):
        ANDROID = "android", "Android"
        IOS = "ios", "iOS"

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="device_tokens",
    )
    token = models.CharField(max_length=512)
    platform = models.CharField(
        max_length=10,
        choices=Platform.choices,
        default=Platform.ANDROID,
    )
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=["user", "token"], name="unique_user_device_token"),
        ]

    def __str__(self) -> str:
        return f"{self.user.email} ({self.platform})"


class NotificationLog(models.Model):
    """Optional analytics for push / in-app notifications."""

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="notification_logs",
    )
    type = models.CharField(max_length=64, db_index=True)
    payload_json = models.JSONField(default=dict, blank=True)
    sent_at = models.DateTimeField(auto_now_add=True)
    read_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ["-sent_at"]
