<?php

declare(strict_types=1);

namespace App\Controllers\Api;

class Health extends BaseApiController
{
    public function index()
    {
        return $this->jsonOk([
            'status' => 'ok',
            'service' => 'macalin-guri-api',
        ]);
    }
}
