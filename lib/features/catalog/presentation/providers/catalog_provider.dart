import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class CatalogProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  // Filter khusus kopi
  List<ProductModel> get coffeeProducts =>
      _products.where((p) => p.category == 'kopi').toList();

  // Filter khusus makanan
  List<ProductModel> get foodProducts =>
      _products.where((p) => p.category == 'makanan').toList();

  // Simulasi fetch data dari API
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    // Simulasi loading jaringan 1.5 detik
    await Future.delayed(const Duration(milliseconds: 1500));
  }
}
