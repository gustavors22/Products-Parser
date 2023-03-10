<?php

namespace App\Http\Controllers\Api\Products;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductsController extends Controller
{
    public function index()
    {
        $products = Product::where('status', '!=', 'trash')->paginate(20);

        return response()->json($products, 200);
    }

    public function show(string $code)
    {
        $product = Product::where('code', $code)->first();

        if (!$product || $product->status == 'trash') {
            return response()->json([
                'message' => 'Product not found'
            ], 404);
        }

        return response()->json($product, 200);
    }

    public function update(Request $request, string $code)
    {
        $product = Product::where('code', $code)->first();

        if (!$product || $product->status == 'trash') {
            return response()->json([
                'message' => 'Product not found'
            ], 404);
        }

        $product->update($request->all());

        return response()->json($product, 200);
    }

    public function destroy(string $code)
    {
        $product = Product::where('code', $code)->first();

        if (!$product || $product->status == 'trash') {
            return response()->json([
                'message' => 'Product not found'
            ], 404);
        }

        $product->update([
            'status' => 'trash'
        ]);

        return response()->json([], 204);
    }
}



