import 'package:flutter/foundation.dart';

class ApiConstants {
  // static getter (get) ngecek kondisi
  static String get baseUrl {
    if (kIsWeb) {
      // Chrome/Web
      return 'http://localhost:8080/v1';
    } else {
      // Android
      return 'http://192.168.1.11:8080/v1';
    }
  }

  //auth endpoints
  static const String verifyToken = '/auth/verify-token';

  //product endpoints
  static const String products = '/products';

  //timeout
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
