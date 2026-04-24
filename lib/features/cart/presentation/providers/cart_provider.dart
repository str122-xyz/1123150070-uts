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

  //tambah barang keranjang
  void addItem(ProductModel product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(product.id, () => CartItem(product: product));
    }
    notifyListeners();
  }

  //mengurangi jumlah brg
  void removeItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      //jika lebih dari 1, kurangi jumlahny
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  //hapus semua isi keranjang
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
