import 'package:uts_apps_market_1123150112/core/constants/api_constants.dart';
import 'package:uts_apps_market_1123150112/core/services/dio_client.dart';
import 'package:uts_apps_market_1123150112/features/dashboard/domain/repositories/product_repository.dart';
import 'package:uts_apps_market_1123150112/features/product/data/models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 10,
    String? category,
  }) async {
    final response = await DioClient.instance.get(
      ApiConstants.products,
      queryParameters: {
        'page':     page,
        'limit':    limit,
        'category': category,
      },
    );

    final dynamic rawData = response.data['data'];
    if (rawData == null || rawData is! List) {
      return [];
    }
    
    return rawData.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await DioClient.instance.get(
      '${ApiConstants.products}/$id',
    );
    return ProductModel.fromJson(response.data['data']);
  }
}
