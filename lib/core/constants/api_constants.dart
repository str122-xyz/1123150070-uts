import 'package:flutter/foundation.dart';

class ApiConstants {
  // static getter (get) ngecek kondisi
  static String get baseUrl {
    if (kIsWeb) {
      // Chrome/Web
      return 'http://localhost:8080/v1';
    } else {
      // Android
      return 'http://192.168.1.4:8080/v1';
    }
  }

  //auth endpoints
  static const String verifyToken = '/auth/verify-token';

  //product endpoints
  static const String products = '/products';

  //cart endpoints
  static const String cart = '/cart';

  //order endpoints
  static const String orders = '/orders';
  static const String checkout = '/orders/checkout';

  //timeout
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
