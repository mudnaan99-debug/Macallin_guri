<?php

declare(strict_types=1);

namespace App\Controllers\Api;

use App\Controllers\BaseController;

abstract class BaseApiController extends BaseController
{
    protected function jsonOk(array $data, int $code = 200)
    {
        return $this->response->setStatusCode($code)->setJSON($data);
    }

    protected function jsonError(array $data, int $code)
    {
        return $this->response->setStatusCode($code)->setJSON($data);
    }
}
