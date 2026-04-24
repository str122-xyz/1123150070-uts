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
      final response = await _apiService.get('/v1/products');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body)['data'];
        return jsonList.map((json) {
          return ProductModel(
            id: (json['id'] ?? json['ID'] ?? json['Id']).toString(),
            name: json['name'] ?? json['Name'] ?? 'Tanpa Nama',
            description: json['description'] ?? json['Description'] ?? '',
            price: double.parse(
              (json['price'] ?? json['Price'] ?? 0).toString(),
            ),
            imageUrl:
                json['image_url'] ??
                json['ImageUrl'] ??
                json['ImageURL'] ??
                json['imageURL'] ??
                '',

            category: (json['category'] ?? json['Category'] ?? '')
                .toString()
                .toLowerCase(),
          );
        }).toList();
      } else {
        throw Exception('Gagal mengambil data produk');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
