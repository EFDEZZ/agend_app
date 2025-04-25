import 'dart:convert';
import 'package:agend_app/src/domain/entities/appointment.dart';
import 'package:agend_app/src/infrastructure/mappers/appointment_mapper.dart';
import 'package:agend_app/src/infrastructure/models/appointment_model.dart';
import 'package:agend_app/src/infrastructure/services/services.dart';
import 'package:http/http.dart' as http;


class AppointmentService {
  final String baseUrl = 'https://ds-appointments-production.up.railway.app/appointments';

  Future<List<Appointment>> getAppointments() async {
    // Obtenemos el token guardado en AuthStorage
    final token = await AuthStorage.getToken();
    
    if (token == null) {
      throw Exception('Token no disponible');
    }

    // Realizamos la solicitud GET pasando el token en los headers
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final appointments = data.map((e) => AppointmentModel.fromJson(e)).toList();
      return AppointmentMapper.toEntityList(appointments);
      
    } else {
      throw Exception('Failed to load appointments');
    }
  }
}
