import 'package:flutter_riverpod/legacy.dart';
import 'package:medstock/config/database/product_dbhelper.dart';
import 'package:medstock/domain/entities/product.dart';

final productListProvider = StateNotifierProvider<ProductListNotifier, List<Product>>((ref) {
  return ProductListNotifier();
});

class ProductListNotifier extends StateNotifier<List<Product>> {
  final ProductDatabaseHelper dbHelper = ProductDatabaseHelper();
  
  ProductListNotifier() : super([]){
    loadProducts();
  }

  Future<void> loadProducts() async {
    final products = await dbHelper.getProducts();
    state = products;
  }

  Future<void> addProduct(Product product) async {
    await dbHelper.insertProduct(product);
    await loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    await dbHelper.updateProduct(product);
    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    await dbHelper.deleteProduct(id);
    await loadProducts();
  }
}