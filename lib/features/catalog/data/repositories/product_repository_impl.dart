import 'dart:convert';
import '../../../../../core/network/api_service.dart';
import '../models/product_model.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiService _apiService;

  ProductRepositoryImpl({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiService.get('/api/products');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body)['data'];
        return jsonList
            .map(
              (json) => ProductModel(
                id: json['id'].toString(),
                name: json['name'],
                description: json['description'],
                price: double.parse(json['price'].toString()),
                imageUrl: json['image_url'],
                category: json['category'],
              ),
            )
            .toList();
      } else {
        throw Exception('Gagal mengambil data produk');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
