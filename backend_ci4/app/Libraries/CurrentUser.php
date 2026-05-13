<?php

declare(strict_types=1);

namespace App\Libraries;

/** Waxaa dejiya JwtAuth filter; Me controller wuu akhrinayaa. */
final class CurrentUser
{
    public static ?int $id = null;

    public static function reset(): void
    {
        self::$id = null;
    }
}
