import 'dart:convert';
import '../../../../../core/network/api_service.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiService.get(
        '/api/products',
      ); // Endpoint backend

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
        throw Exception('Gagal mengambil data produk dari server');
      }
    } catch (e) {
      throw Exception('Error jaringan: $e');
    }
  }
}
