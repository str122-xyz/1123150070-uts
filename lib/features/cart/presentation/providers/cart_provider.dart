import 'package:flutter/material.dart';
import '../../../catalog/data/models/product_model.dart';

//Model kecil untuk item di keranjang (menyimpan jumlah/quantity)
class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  //mengambil semua barang di keranjang
  Map<String, CartItem> get items => _items;

  //hitung total jumlah barang
  int get itemCount => _items.length;

  //hitung total harga semua barang
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }
}
