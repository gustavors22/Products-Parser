<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JsonInserted extends Model
{
    use HasFactory;

    protected $table = 'json_inserted';

    protected $fillable = [
        'file_name'
    ];
}
