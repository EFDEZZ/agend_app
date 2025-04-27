import 'dart:convert';

import 'package:agend_app/src/infrastructure/services/services.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static const String _baseUrl = 'https://ds-appointments-production.up.railway.app';

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final token = result['access_token'];

        if (token != null) {
          await AuthStorage.saveToken(token);
          return true;
        } else {
          throw Exception('Token no encontrado en la respuesta');
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Error desconocido');
      }
    } catch (e) {
      throw Exception('Error en LoginService: $e');
    }
  }
}
