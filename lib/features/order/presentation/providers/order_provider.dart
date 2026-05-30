import 'package:flutter/material.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repository.dart';

enum OrderStatus { initial, loading, success, error }

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository = OrderRepositoryImpl();

  OrderModel? _selectedOrder;
  OrderStatus _checkoutStatus = OrderStatus.initial;
  OrderModel? _lastOrder; // untuk menyimpan order terakhir yg berhasil
  List<OrderModel> _orders = [];
  String? _error;

  // getter
  OrderStatus get checkoutStatus => _checkoutStatus;
  OrderModel? get lastOrder => _lastOrder;
  OrderModel? get selectedOrder => _selectedOrder;
  List<OrderModel> get orders => _orders;
  String? get error => _error;

  void _setLoading() {
    _checkoutStatus = OrderStatus.loading;
    notifyListeners();
  }

  void _setError(String msg) {
    _error = msg;
    _checkoutStatus = OrderStatus.error;
    notifyListeners();
  }

  Future<bool> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  }) async {
    _setLoading();
    try {
      _lastOrder = await _repository.checkout(
        shippingAddress: shippingAddress,
        notes: notes,
        paymentMethod: paymentMethod,
      );
      _checkoutStatus = OrderStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Fungsi untuk mengambil riwayat pesanan dari backend
  Future<void> fetchOrders() async {
    try {
      final fetchedOrders = await _repository.getMyOrders();

      _orders = fetchedOrders;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Fungsi untuk mengambil detail pesanan berdasarkan ID
  Future<void> fetchOrderDetail(int orderId) async {
    try {
      _selectedOrder = null;
      notifyListeners();

      final detail = await _repository.getOrderDetail(orderId);

      _selectedOrder = detail;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
