<?php

declare(strict_types=1);

namespace App\Controllers\Api;

use App\Libraries\Pbkdf2PasswordHasher;
use App\Models\UsersUserModel;

class Register extends BaseApiController
{
    public function create()
    {
        $body = $this->request->getJSON(true);
        if (! is_array($body)) {
            return $this->jsonError(['detail' => 'Invalid JSON body.'], 400);
        }
        $email = isset($body['email']) ? trim((string) $body['email']) : '';
        $password = isset($body['password']) ? (string) $body['password'] : '';
        $name = isset($body['name']) ? trim((string) $body['name']) : '';
        $phone = isset($body['phone']) ? trim((string) $body['phone']) : '';
        $role = isset($body['role']) ? trim((string) $body['role']) : 'student';

        $errors = [];
        if ($email === '' || ! filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $errors['email'] = ['Enter a valid email address.'];
        }
        if (strlen($password) < 6) {
            $errors['password'] = ['Ensure this field has at least 6 characters.'];
        }
        if ($name === '') {
            $errors['name'] = ['This field may not be blank.'];
        }
        if ($role === 'admin') {
            $errors['role'] = ['Cannot register as admin via API.'];
        }
        if ($errors !== []) {
            return $this->jsonError($errors, 400);
        }

        $model = new UsersUserModel();
        if ($model->findByEmail($email) !== null) {
            return $this->jsonError(['email' => ['user with this email address already exists.']], 400);
        }

        $now = date('Y-m-d H:i:s');
        $phoneVal = $phone === '' ? null : $phone;
        if ($phoneVal !== null) {
            $dup = $model->where('phone', $phoneVal)->first();
            if ($dup !== null) {
                return $this->jsonError(['phone' => ['user with this phone number already exists.']], 400);
            }
        }

        $encoded = Pbkdf2PasswordHasher::encode($password);
        $id = $model->insert([
            'password' => $encoded,
            'last_login' => null,
            'is_superuser' => 0,
            'first_name' => '',
            'last_name' => '',
            'is_staff' => 0,
            'is_active' => 1,
            'date_joined' => $now,
            'email' => $email,
            'name' => $name,
            'phone' => $phoneVal,
            'role' => $role,
            'profile_image' => '',
            'status' => 'active',
            'created_at' => $now,
        ]);
        if ($id === false) {
            return $this->jsonError(['detail' => 'Could not create user.'], 500);
        }
        $row = $model->find($id);

        return $this->jsonOk(UsersUserModel::toApiArray($row), 201);
    }
}
