<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CronExecutation extends Model
{
    use HasFactory;

    protected $table = 'cron_executations';

    protected $fillable = [
        'runned_at'
    ];
}
