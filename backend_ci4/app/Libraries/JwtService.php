<?php

declare(strict_types=1);

namespace App\Libraries;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

/**
 * JWT HS256 — jawaabta Flutter / SimpleJWT (access, refresh, user_id).
 */
final class JwtService
{
    public static function secret(): string
    {
        $s = env('jwt.secret', '');
        if ($s === '') {
            throw new \RuntimeException('Set jwt.secret in .env');
        }

        return $s;
    }

    public static function accessTtl(): int
    {
        return (int) env('jwt.accessTtl', 3600);
    }

    public static function refreshTtl(): int
    {
        return (int) env('jwt.refreshTtl', 604800);
    }

    /**
     * @return array{access: string, refresh: string}
     */
    public static function issuePair(int $userId): array
    {
        $now = time();
        $jtiAccess = bin2hex(random_bytes(8));
        $jtiRefresh = bin2hex(random_bytes(8));

        $accessPayload = [
            'token_type' => 'access',
            'exp' => $now + self::accessTtl(),
            'iat' => $now,
            'jti' => $jtiAccess,
            'user_id' => $userId,
        ];
        $refreshPayload = [
            'token_type' => 'refresh',
            'exp' => $now + self::refreshTtl(),
            'iat' => $now,
            'jti' => $jtiRefresh,
            'user_id' => $userId,
        ];
        $key = self::secret();

        return [
            'access' => JWT::encode($accessPayload, $key, 'HS256'),
            'refresh' => JWT::encode($refreshPayload, $key, 'HS256'),
        ];
    }

    /**
     * @return array{user_id: int, token_type: string}
     */
    public static function decode(string $jwt): array
    {
        $decoded = JWT::decode($jwt, new Key(self::secret(), 'HS256'));
        $arr = (array) $decoded;
        if (! isset($arr['user_id'], $arr['token_type'])) {
            throw new \RuntimeException('Invalid token claims');
        }

        return [
            'user_id' => (int) $arr['user_id'],
            'token_type' => (string) $arr['token_type'],
        ];
    }
}
