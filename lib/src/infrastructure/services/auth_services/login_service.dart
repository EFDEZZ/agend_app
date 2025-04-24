import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String _baseUrl = 'https://ds-appointments-production.up.railway.app';
  
  // Método para iniciar sesión
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Verificar conexión a internet
      try {
        await InternetAddress.lookup('railway.app');
      } on SocketException {
        return {'success': false, 'message': 'No internet connection'};
      }

      // 2. Construir la petición
      final url = Uri.parse('$_baseUrl/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      // 3. Procesar respuesta
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        // Login exitoso
        final token = responseData['access_token'];
        await _saveAuthToken(token); // Guardar token
        
        return {
          'success': true,
          'token': token,
          'token_type': responseData['token_type'],
        };
      } else {
        // Error en el login
        return {
          'success': false,
          'message': responseData['detail'] ?? 'Login failed. Status: ${response.statusCode}',
        };
      }
    } on SocketException {
      return {'success': false, 'message': 'Could not connect to server'};
    } on TimeoutException {
      return {'success': false, 'message': 'Connection timeout'};
    } on FormatException {
      return {'success': false, 'message': 'Invalid server response'};
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // Guardar token en SharedPreferences
  static Future<void> _saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Obtener token guardado
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Verificar si hay un usuario logueado
  static Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Obtener headers con autenticación
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }
}