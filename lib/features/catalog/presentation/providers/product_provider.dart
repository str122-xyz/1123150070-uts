import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/product_repository_impl.dart';

class CatalogProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepositoryImpl();
  List<ProductModel> _products = [];
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  List<ProductModel> get coffeeProducts =>
      _products.where((p) => p.category == 'kopi').toList();

  List<ProductModel> get foodProducts =>
      _products.where((p) => p.category == 'makanan').toList();

  // Simulasi fetch data dari API
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // ---------------------------------------------------------
      // Saklar API: Buka kalo Golang udah jalan
      // ---------------------------------------------------------
      _products = await _repository.getProducts();

      // ---------------------------------------------------------
      // Saklar dummy
      // ---------------------------------------------------------
      await Future.delayed(const Duration(milliseconds: 1000));
      /*
      _products = [
        //kategori minuman kopi
        const ProductModel(
          id: 'c1',
          name: 'Kopi Susu Ngopss',
          description:
              'Signature espresso dengan susu segar dan gula aren asli.',
          price: 25000,
          imageUrl:
              'https://images.unsplash.com/photo-1557006021-b85faa2bc5e2?q=80&w=500&auto=format&fit=crop',
          category: 'kopi',
        ),
        const ProductModel(
          id: 'c2',
          name: 'Caffe Latte',
          description:
              'Kombinasi sempurna espresso dan steamed milk yang lembut.',
          price: 28000,
          imageUrl:
              'https://images.unsplash.com/photo-1572442388796-11668a67e53d?q=80&w=500&auto=format&fit=crop',
          category: 'kopi',
        ),
        const ProductModel(
          id: 'c3',
          name: 'Americano',
          description: 'Definisi dari pahitnya kehidupan.',
          price: 20000,
          imageUrl:
              'https://images.unsplash.com/photo-1551030173-122aabc4489c?q=80&w=500&auto=format&fit=crop',
          category: 'kopi',
        ),

        //kategori makanan
        const ProductModel(
          id: 'f1',
          name: 'Butter Croissant',
          description:
              'Pastry Prancis klasik yang renyah di luar dan lembut di dalam.',
          price: 22000,
          imageUrl:
              'https://images.unsplash.com/photo-1549903072-7e6e0ebc9056?q=80&w=500&auto=format&fit=crop',
          category: 'makanan',
        ),
        const ProductModel(
          id: 'f2',
          name: 'Choco Brownie',
          description: 'Fudgy brownie padat dengan potongan dark chocolate.',
          price: 18000,
          imageUrl:
              'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?q=80&w=500&auto=format&fit=crop',
          category: 'makanan',
        ),
        const ProductModel(
          id: 'f3',
          name: 'Pisang Goreng',
          description: 'Pisang goreng enak muanis.',
          price: 15000,
          imageUrl:
              'https://images.unsplash.com/photo-1762941904142-9d91ca413e66?q=80&w=735&auto=format&fit=crop',
          category: 'makanan',
        ),
      ];
      */
    } catch (e) {
      debugPrint('Error fetch API: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
