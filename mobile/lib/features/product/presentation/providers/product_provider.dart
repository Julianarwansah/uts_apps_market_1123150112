import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uts_apps_market_1123150112/features/dashboard/domain/repositories/product_repository.dart';
import 'package:uts_apps_market_1123150112/features/dashboard/domain/repositories/product_repository_impl.dart';
import 'package:uts_apps_market_1123150112/features/product/data/models/product_model.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  // Menggunakan repository untuk mengambil data produk lewat DioClient
  final ProductRepository _repository = ProductRepositoryImpl();

  ProductStatus       _status   = ProductStatus.initial;
  List<ProductModel>  _products = [];
  String?             _error;

  ProductStatus      get status    => _status;
  List<ProductModel> get products  => _products;
  String?            get error     => _error;
  bool               get isLoading => _status == ProductStatus.loading;

  Future<void> fetchProducts() async {
    _status = ProductStatus.loading;
    notifyListeners();

    try {
      _products = await _repository.getProducts();
      _status   = ProductStatus.loaded;
    } on DioException catch (e) {
      _error  = e.response?.data['message'] ?? 'Gagal memuat produk';
      _status = ProductStatus.error;
    } catch (e) {
      _error  = 'Terjadi kesalahan data: $e';
      _status = ProductStatus.error;
    }

    notifyListeners();
  }
}
