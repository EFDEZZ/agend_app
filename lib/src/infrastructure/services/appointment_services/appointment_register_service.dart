import 'dart:convert';

import 'package:agend_app/src/infrastructure/services/services.dart';
import 'package:http/http.dart' as http;

class RegisterAppointmentService {
  final String baseUrl = 'https://ds-appointments-production.up.railway.app/appointment';

  Future<bool> registerAppointment({
    required DateTime date,
    required String service,
    required String notes,
  }) async {
    try {
      final token = await AuthStorage.getToken();
      if (token == null) throw Exception("Token no encontrado");

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "date_time": date.toUtc().toIso8601String(),
          "service": service,
          "notes": notes,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to register appointment: $e');
    }
  }
}
