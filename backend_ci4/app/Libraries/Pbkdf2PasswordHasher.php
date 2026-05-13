<?php

declare(strict_types=1);

namespace App\Libraries;

/**
 * Verify and create `users_user.password` values: `pbkdf2_sha256$iterations$salt$hash` (PBKDF2-SHA256, 32-byte key).
 */
final class Pbkdf2PasswordHasher
{
    private const ITERATIONS_REGISTER = 1_000_000;

    public static function verify(string $plain, string $encoded): bool
    {
        if (! str_starts_with($encoded, 'pbkdf2_sha256$')) {
            return false;
        }
        $parts = explode('$', $encoded, 4);
        if (count($parts) !== 4) {
            return false;
        }
        [, $iterStr, $salt, $hashB64] = $parts;
        $iterations = (int) $iterStr;
        if ($iterations < 1) {
            return false;
        }
        $hash = base64_decode($hashB64, true);
        if ($hash === false) {
            return false;
        }
        $dkLen = strlen($hash);
        $derived = hash_pbkdf2('sha256', $plain, $salt, $iterations, $dkLen, true);

        return hash_equals($hash, $derived);
    }

    public static function encode(string $plain): string
    {
        $salt = self::randomSalt();
        $iterations = self::ITERATIONS_REGISTER;
        $hashBin = hash_pbkdf2('sha256', $plain, $salt, $iterations, 32, true);
        $hashB64 = base64_encode($hashBin);

        return 'pbkdf2_sha256' . '$' . $iterations . '$' . $salt . '$' . $hashB64;
    }

    private static function randomSalt(): string
    {
        $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        $out = '';
        for ($i = 0; $i < 22; $i++) {
            $out .= $chars[random_int(0, strlen($chars) - 1)];
        }

        return $out;
    }
}
