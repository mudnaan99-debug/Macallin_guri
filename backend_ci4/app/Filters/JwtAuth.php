<?php

declare(strict_types=1);

namespace App\Filters;

use App\Libraries\CurrentUser;
use App\Libraries\JwtService;
use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Throwable;

class JwtAuth implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        CurrentUser::reset();
        $auth = $request->getHeaderLine('Authorization');
        if (! preg_match('/^Bearer\s+(\S+)/i', $auth, $m)) {
            return $this->json401('Authentication credentials were not provided.');
        }
        try {
            $claims = JwtService::decode($m[1]);
            if ($claims['token_type'] !== 'access') {
                return $this->json401('Token is not an access token.');
            }
            CurrentUser::$id = $claims['user_id'];
        } catch (Throwable $e) {
            return $this->json401('Given token not valid for any token type');
        }

        return null;
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
        CurrentUser::reset();

        return $response;
    }

    private function json401(string $detail): ResponseInterface
    {
        return service('response')
            ->setStatusCode(401)
            ->setJSON(['detail' => $detail]);
    }
}
