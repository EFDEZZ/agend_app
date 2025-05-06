import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String _baseUrl = 'https://ds-appointments-production.up.railway.app';

  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final connected = await _checkInternetConnection();
    if (!connected) throw SocketException('No internet connection');

    final url = Uri.parse('$_baseUrl/signup');

    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': name,
            'email': email,
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 10));

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': 'Successful registration',
        'userData': {
          'id': responseData['id'],
          'name': responseData['name'],
          'email': responseData['email'],
          'is_admin': responseData['is_admin'] ?? false,
        },
      };
    } else {
      throw HttpException(
        responseData['detail'] ??
        'Registration failed with status code ${response.statusCode}',
      );
    }
  }

  static Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
