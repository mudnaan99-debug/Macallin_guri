from django.contrib import admin

from .models import (
    Booking,
    Job,
    JobApplication,
    Message,
    Review,
    Subject,
    Tutor,
    TutorSubject,
)


@admin.register(Subject)
class SubjectAdmin(admin.ModelAdmin):
    search_fields = ("name",)


class TutorSubjectInline(admin.TabularInline):
    model = TutorSubject
    extra = 1


@admin.register(Tutor)
class TutorAdmin(admin.ModelAdmin):
    list_display = ("user", "tutor_status", "is_verified", "hourly_rate", "location")
    list_filter = ("tutor_status", "is_verified")
    search_fields = ("user__email", "user__name", "location")
    inlines = [TutorSubjectInline]


@admin.register(Job)
class JobAdmin(admin.ModelAdmin):
    list_display = ("title", "publisher", "status", "created_at")
    list_filter = ("status",)
    search_fields = ("title", "description")


@admin.register(JobApplication)
class JobApplicationAdmin(admin.ModelAdmin):
    list_display = ("job", "tutor", "status", "created_at")
    list_filter = ("status",)


@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ("id", "tutor", "subject", "session_date", "status")
    list_filter = ("status", "session_type")


@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    list_display = ("tutor", "student_user", "rating", "created_at")


@admin.register(Message)
class MessageAdmin(admin.ModelAdmin):
    list_display = ("sender", "receiver", "created_at")
