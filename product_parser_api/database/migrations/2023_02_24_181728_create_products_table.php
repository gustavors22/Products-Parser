<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->longText('code');
            $table->enum('status', ['published', 'draft', 'trash']);
            $table->longText('imported_t');
            $table->longText('url');
            $table->longText('creator');
            $table->longText('created_t');
            $table->longText('last_modified_t');
            $table->longText('product_name');
            $table->longText('quantity');
            $table->longText('brands');
            $table->longText('categories');
            $table->longText('labels');
            $table->longText('cities');
            $table->longText('purchase_places');
            $table->longText('stores');
            $table->longText('ingredients_text');
            $table->longText('traces');
            $table->longText('serving_size');
            $table->longText('serving_quantity');
            $table->longText('nutriscore_score');
            $table->longText('nutriscore_grade');
            $table->longText('main_category');
            $table->longText('image_url');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('products');
    }
};