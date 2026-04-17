class ApiConstants {
  static const String baseUrl = 'http://192.168.0.28:8080/v1';

  //auth endpoints
  static const String verifyToken = '/auth/verify-token';

  //product endpoints
  static const String products = '/products';

  //timeout
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
