import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class RegisterService {
  static const String _baseUrl = 'https://ds-appointments-production.up.railway.app';

  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Verificación de conexión a internet
      try {
        await InternetAddress.lookup('railway.app');
      } on SocketException catch (_) {
        return {'success': false, 'message': 'No hay conexión a internet'};
      }

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
        // Respuesta exitosa - ajustada a la estructura real de tu API
        return {
          'success': true,
          'message': 'Successful registration',
          'userData': {
            // Ahora devolvemos todos los datos del usuario
            'id': responseData['id'],
            'name': responseData['name'],
            'email': responseData['email'],
            'is_admin': responseData['is_admin'] ?? false,
          },
          // Nota: Esta API no parece devolver un token en el registro
          // Si lo necesitas para autenticación, verifica con el backend
        };
      } else {
        return {
          'success': false,
          'message':
              responseData['detail'] ??
              'Error en el registro. Código: ${response.statusCode}',
        };
      }
    } on SocketException {
      return {'success': false, 'message': 'No se pudo conectar al servidor'};
    } on TimeoutException {
      return {'success': false, 'message': 'Tiempo de espera agotado'};
    } on FormatException {
      return {
        'success': false,
        'message': 'Error al procesar la respuesta del servidor',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: ${e.toString()}'};
    }
  }
}
