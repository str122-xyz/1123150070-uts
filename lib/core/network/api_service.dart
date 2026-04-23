import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/service_storage.dart';

class ApiService {
  //ganti URL jika Golang udah di-hosting atau pakai IP lokal
  static const String baseUrl = 'http://localhost:8080';

  Future<Map<String, String>> _getHeaders() async {
    final token = await SecureStorageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    return await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
