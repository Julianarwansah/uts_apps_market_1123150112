import 'package:uts_apps_market_1123150112/features/product/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts({int page = 1, int limit = 10, String? category});
  Future<ProductModel> getProductById(int id);
}
