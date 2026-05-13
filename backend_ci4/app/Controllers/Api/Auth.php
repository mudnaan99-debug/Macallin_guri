<?php

declare(strict_types=1);

namespace App\Controllers\Api;

use App\Libraries\Pbkdf2PasswordHasher;
use App\Libraries\JwtService;
use App\Models\UsersUserModel;

class Auth extends BaseApiController
{
    public function token()
    {
        $body = $this->request->getJSON(true);
        if (! is_array($body)) {
            return $this->jsonError(['detail' => 'Invalid JSON body.'], 400);
        }
        $email = isset($body['email']) ? trim((string) $body['email']) : '';
        $password = isset($body['password']) ? (string) $body['password'] : '';
        if ($email === '' || $password === '') {
            return $this->jsonError(['detail' => 'Must include "email" and "password".'], 400);
        }

        $model = new UsersUserModel();
        $user = $model->findByEmail($email);
        if ($user === null) {
            return $this->json401();
        }
        if ((int) ($user['is_active'] ?? 0) !== 1 || ($user['status'] ?? '') === 'blocked') {
            return $this->json401();
        }
        $hash = (string) ($user['password'] ?? '');
        if (! Pbkdf2PasswordHasher::verify($password, $hash)) {
            return $this->json401();
        }

        $pair = JwtService::issuePair((int) $user['id']);

        return $this->jsonOk([
            'refresh' => $pair['refresh'],
            'access' => $pair['access'],
        ]);
    }

    public function refresh()
    {
        $body = $this->request->getJSON(true);
        if (! is_array($body) || empty($body['refresh'])) {
            return $this->jsonError(['detail' => 'Must include "refresh" token.'], 400);
        }
        $token = (string) $body['refresh'];
        try {
            $claims = JwtService::decode($token);
            if ($claims['token_type'] !== 'refresh') {
                return $this->jsonError(['detail' => 'Token has wrong type'], 401);
            }
            $pair = JwtService::issuePair($claims['user_id']);

            return $this->jsonOk([
                'refresh' => $pair['refresh'],
                'access' => $pair['access'],
            ]);
        } catch (\Throwable $e) {
            return $this->jsonError(['detail' => 'Token is invalid or expired', 'code' => 'token_not_valid'], 401);
        }
    }

    private function json401()
    {
        return $this->jsonError([
            'detail' => 'No active account found with the given credentials.',
        ], 401);
    }
}
