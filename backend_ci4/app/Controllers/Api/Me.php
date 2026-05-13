<?php

declare(strict_types=1);

namespace App\Controllers\Api;

use App\Libraries\CurrentUser;
use App\Models\UsersUserModel;

class Me extends BaseApiController
{
    public function index()
    {
        $uid = CurrentUser::$id;
        if ($uid === null) {
            return $this->jsonError(['detail' => 'Authentication credentials were not provided.'], 401);
        }
        $model = new UsersUserModel();
        $user = $model->find($uid);
        if ($user === null) {
            return $this->jsonError(['detail' => 'User not found.'], 404);
        }

        return $this->jsonOk(UsersUserModel::toApiArray($user));
    }
}
