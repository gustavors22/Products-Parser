<?php

use App\Http\Controllers\Api\ApiInformationsController;
use App\Http\Controllers\Api\Products\ProductsController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::get('/', ApiInformationsController::class);

Route::group([], function () {
    Route::get('products', [ProductsController::class, 'index']);
    Route::get('products/{code}', [ProductsController::class, 'show']);
    Route::put('products/{code}', [ProductsController::class, 'update']);
    Route::delete('products/{code}', [ProductsController::class, 'destroy']);
});
