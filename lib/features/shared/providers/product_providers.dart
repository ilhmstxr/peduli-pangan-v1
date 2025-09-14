// lib/providers/product_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
// import '../features/shared/services/product_service.dart';
import '../services/product_services.dart';
// 

// 1. Provider untuk ProductService
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

// 2. Provider untuk mengambil SEMUA produk (ViewModel untuk daftar produk)
final allProductsProvider = FutureProvider<List<Product>>((ref) {
  final service = ref.read(productServiceProvider);
  return service.getAllProductsWithMerchant();
});

// 3. Provider untuk mengambil SATU produk berdasarkan ID
//    .family digunakan agar kita bisa memberikan parameter (ID produk) ke provider
final productByIdProvider = FutureProvider.family<Product, int>((ref, productId) {
  final service = ref.read(productServiceProvider);
  return service.getProductById(productId);
});