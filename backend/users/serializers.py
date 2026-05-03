from django.contrib.auth import get_user_model
from rest_framework import serializers

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
            "id",
            "email",
            "name",
            "phone",
            "role",
            "profile_image",
            "status",
            "created_at",
        )
        read_only_fields = fields


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=6)
    phone = serializers.CharField(required=False, allow_blank=True, allow_null=True, max_length=32)

    class Meta:
        model = User
        fields = ("email", "password", "name", "phone", "role")

    def validate_role(self, value):
        if value == User.Role.ADMIN:
            raise serializers.ValidationError("Cannot register as admin via API.")
        return value

    def create(self, validated_data):
        password = validated_data.pop("password")
        return User.objects.create_user(
            email=validated_data["email"],
            password=password,
            name=validated_data["name"],
            phone=validated_data.get("phone") or None,
            role=validated_data.get("role", get_user_model().Role.STUDENT),
        )
