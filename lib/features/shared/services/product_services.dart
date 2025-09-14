// lib/services/product_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Mengambil SEMUA produk yang ada, beserta data merchant pemiliknya
  Future<List<Product>> getAllProductsWithMerchant() async {
    try {
      // Ambil semua dari tabel 'products' dan sertakan data dari tabel 'merchants' yang berelasi
      final response = await _supabase
          .from('products')
          .select('*, merchants(*)');
      
      return (response as List)
          .map((product) => Product.fromJson(product))
          .toList();
    } catch (e) {
      // Menangani error jika terjadi
      print('Error fetching all products: $e');
      throw Exception('Gagal mengambil data produk: $e');
    }
  }

  // Mengambil SATU produk spesifik berdasarkan ID-nya
  Future<Product> getProductById(int productId) async {
    try {
      final response = await _supabase
          .from('products')
          .select('*, merchants(*)') // Sertakan juga data merchant-nya
          .eq('id', productId)
          .single(); // Ambil satu baris saja

      return Product.fromJson(response);
    } catch (e) {
      print('Error fetching product by ID: $e');
      throw Exception('Gagal mengambil detail produk: $e');
    }
  }
}