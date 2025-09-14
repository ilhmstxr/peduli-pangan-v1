import 'product_model.dart';
import 'product_filters.dart';

abstract class ProductRepository {
  Future<List<Product>> list(ProductFilters filters);
  Future<Product?> getById(int id);
  Future<Product> create(Product input);
  Future<Product> update(int id, Product input);
  Future<void> delete(int id);          // hard delete; gunakan is_active=false untuk soft delete
}
