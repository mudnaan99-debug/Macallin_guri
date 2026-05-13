<?php

declare(strict_types=1);

namespace App\Models;

use CodeIgniter\Model;

class UsersUserModel extends Model
{
    protected $table = 'users_user';
    protected $primaryKey = 'id';
    protected $useAutoIncrement = true;
    protected $returnType = 'array';
    protected $allowedFields = [
        'password',
        'last_login',
        'is_superuser',
        'first_name',
        'last_name',
        'is_staff',
        'is_active',
        'date_joined',
        'email',
        'name',
        'phone',
        'role',
        'profile_image',
        'status',
        'created_at',
    ];

    public function findByEmail(string $email): ?array
    {
        $row = $this->where('email', $email)->first();

        return $row ?: null;
    }

    public function findActiveByEmail(string $email): ?array
    {
        $row = $this->where('email', $email)
            ->where('is_active', 1)
            ->where('status', 'active')
            ->first();

        return $row ?: null;
    }

    /**
     * JSON shape for `/api/me` (Flutter `UserModel.fromApiJson`).
     */
    public static function toApiArray(array $row): array
    {
        return [
            'id' => (int) $row['id'],
            'email' => $row['email'],
            'name' => $row['name'],
            'phone' => $row['phone'],
            'role' => $row['role'],
            'profile_image' => $row['profile_image'] ?? '',
            'status' => $row['status'] ?? 'active',
            'created_at' => self::formatIso($row['created_at'] ?? null),
        ];
    }

    private static function formatIso(?string $dt): string
    {
        if ($dt === null || $dt === '') {
            return gmdate('c');
        }
        $ts = strtotime($dt . ' UTC');

        return $ts ? gmdate('c', $ts) : gmdate('c');
    }
}
