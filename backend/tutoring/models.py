from django.conf import settings
from django.core.exceptions import ValidationError
from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models


User = settings.AUTH_USER_MODEL


class Subject(models.Model):
    name = models.CharField(max_length=128, unique=True)

    class Meta:
        ordering = ["name"]

    def __str__(self) -> str:
        return self.name


class Tutor(models.Model):
    """Tutor profile — one per user with role tutor."""

    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name="tutor_profile",
    )
    bio = models.TextField(blank=True, default="")
    experience_years = models.PositiveSmallIntegerField(default=0)
    hourly_rate = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    rating = models.DecimalField(max_digits=3, decimal_places=2, default=0)
    location = models.CharField(max_length=255, blank=True, default="")
    is_verified = models.BooleanField(default=False)

    class TutorStatus(models.TextChoices):
        PENDING = "pending", "Pending"
        APPROVED = "approved", "Approved"
        REJECTED = "rejected", "Rejected"

    tutor_status = models.CharField(
        max_length=20,
        choices=TutorStatus.choices,
        default=TutorStatus.PENDING,
        db_index=True,
    )
    rejection_reason = models.TextField(blank=True, default="")
    created_at = models.DateTimeField(auto_now_add=True)
    subjects = models.ManyToManyField(
        Subject,
        through="TutorSubject",
        related_name="tutors",
        blank=True,
    )

    class Meta:
        ordering = ["-created_at"]

    def __str__(self) -> str:
        return f"Tutor({self.user.email})"


class TutorSubject(models.Model):
    tutor = models.ForeignKey(Tutor, on_delete=models.CASCADE)
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=("tutor", "subject"),
                name="unique_tutor_subject",
            ),
        ]


class Job(models.Model):
    publisher = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="posted_jobs",
    )
    title = models.CharField(max_length=255)
    description = models.TextField()
    subject = models.ForeignKey(
        Subject,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="jobs",
    )
    location = models.CharField(max_length=255, blank=True, default="")
    salary_or_budget = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    schedule_hint = models.CharField(max_length=255, blank=True, default="")

    class JobStatus(models.TextChoices):
        OPEN = "open", "Open"
        CLOSED = "closed", "Closed"
        FILLED = "filled", "Filled"

    status = models.CharField(
        max_length=20,
        choices=JobStatus.choices,
        default=JobStatus.OPEN,
        db_index=True,
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self) -> str:
        return self.title


class JobApplication(models.Model):
    job = models.ForeignKey(Job, on_delete=models.CASCADE, related_name="applications")
    tutor = models.ForeignKey(Tutor, on_delete=models.CASCADE, related_name="job_applications")

    class ApplicationStatus(models.TextChoices):
        PENDING = "pending", "Pending"
        ACCEPTED = "accepted", "Accepted"
        REJECTED = "rejected", "Rejected"

    status = models.CharField(
        max_length=20,
        choices=ApplicationStatus.choices,
        default=ApplicationStatus.PENDING,
        db_index=True,
    )
    message = models.TextField(blank=True, default="")
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=("job", "tutor"),
                name="unique_job_tutor_application",
            ),
        ]
        ordering = ["-created_at"]


class Booking(models.Model):
    student_user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name="bookings_as_student",
    )
    parent_user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name="bookings_as_parent",
    )
    tutor = models.ForeignKey(Tutor, on_delete=models.CASCADE, related_name="bookings")
    subject = models.ForeignKey(Subject, on_delete=models.PROTECT, related_name="bookings")

    session_date = models.DateField()
    start_time = models.TimeField()
    end_time = models.TimeField()

    class SessionType(models.TextChoices):
        ONLINE = "online", "Online"
        PHYSICAL = "physical", "Physical"

    session_type = models.CharField(
        max_length=20,
        choices=SessionType.choices,
        default=SessionType.ONLINE,
    )

    class BookingStatus(models.TextChoices):
        PENDING = "pending", "Pending"
        ACCEPTED = "accepted", "Accepted"
        COMPLETED = "completed", "Completed"
        CANCELLED = "cancelled", "Cancelled"

    status = models.CharField(
        max_length=20,
        choices=BookingStatus.choices,
        default=BookingStatus.PENDING,
        db_index=True,
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]
        constraints = [
            models.CheckConstraint(
                check=(
                    models.Q(student_user__isnull=False) | models.Q(parent_user__isnull=False)
                ),
                name="booking_student_or_parent_required",
            ),
        ]

    def clean(self) -> None:
        super().clean()
        if not self.student_user and not self.parent_user:
            raise ValidationError("Booking requires student_user or parent_user.")
        if self.end_time <= self.start_time:
            raise ValidationError("end_time must be after start_time.")


class Review(models.Model):
    student_user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="reviews_written",
    )
    tutor = models.ForeignKey(Tutor, on_delete=models.CASCADE, related_name="reviews")
    rating = models.PositiveSmallIntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(5)],
    )
    comment = models.TextField(blank=True, default="")
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]


class Message(models.Model):
    """Direct messages (design §4.7) — simple sender/receiver model."""

    sender = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="messages_sent",
    )
    receiver = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="messages_received",
    )
    body = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]
        indexes = [
            models.Index(fields=["sender", "receiver", "-created_at"]),
        ]
