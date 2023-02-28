<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CronExecutation;
use Illuminate\Support\Facades\DB;

class ApiInformationsController extends Controller
{
    public function __invoke()
    {
        try {
            DB::connection()->getPdo();
        } catch (\Exception $e) {
            return response()->json(['message' => 'Error in database connection'], 500);
        }

        $uptime = exec('uptime');
        if (!$uptime) {
            $uptime = 'Not is possible to determine the server uptime';
        }

        $memoryUsage = memory_get_usage(true);

        return response()->json([
            'message' => 'This is a challenge by Coodesh.',
            'database_connection' => 'OK',
            'last_cron_run' => CronExecutation::all()->last()->runned_at ?? 'Not is possible to determine the last cron run',
            'server_uptime' => $uptime,
            'memory_usage' => $memoryUsage
        ]);
    }
}
