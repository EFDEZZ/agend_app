import 'dart:convert';

import 'package:agend_app/src/domain/datasources/appointment_datasource.dart';
import 'package:agend_app/src/domain/entities/appointment.dart';
import 'package:agend_app/src/infrastructure/mappers/appointment_mapper.dart';
import 'package:agend_app/src/infrastructure/models/appointment_model.dart';
import 'package:agend_app/src/infrastructure/services/services.dart';
import 'package:http/http.dart' as http;

class AppointmentAPIDatasource extends AppointmentDatasource {
  final String baseUrl = 'https://ds-appointments-production.up.railway.app';

  @override
  Future<bool> createAppointment({
    required DateTime date,
    required String service,
    required String notes,
    required String phone,
  }) async {
    try {
      final token = await AuthStorage.getToken();
      if (token == null) throw Exception("Token not found");

      final response = await http.post(
        Uri.parse('$baseUrl/appointment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "date_time": date.toUtc().toIso8601String(),
          "service": service,
          "notes": notes,
          "clientPhone": phone,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to register appointment: $e');
    }
  }

  @override
  Future<List<Appointment>> getAppointmentsByUser() async {
    // Obtenemos el token guardado en AuthStorage
    final token = await AuthStorage.getToken();

    if (token == null) {
      return Future.value([]); 
    }

    // Realizamos la solicitud GET pasando el token en los headers
    final response = await http.get(
      Uri.parse('$baseUrl/appointments'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final appointments =
          data.map((e) => AppointmentModel.fromJson(e)).toList();
      return AppointmentMapper.toEntityList(appointments);
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  @override
  Future<List<Appointment>> getAllAppointments() async {
    // Obtenemos el token guardado en AuthStorage
    final token = await AuthStorage.getToken();

    if (token == null) {
      return Future.value([]); 
    }

    // Realizamos la solicitud GET pasando el token en los headers
    final response = await http.get(
      Uri.parse('$baseUrl/all_appointments'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final appointments =
          data.map((e) => AppointmentModel.fromJson(e)).toList();
      return AppointmentMapper.toEntityList(appointments);
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  @override
  Future<void> deleteAppointment(int appointmentId) async {
    final token = await AuthStorage.getToken();

    if (token == null) {
      return Future.value([]); 
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/appointments/$appointmentId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar cita: ${response.body}');
    }
  }

  @override
  Future<Appointment> getAppointmentDetails(int id) async {
    final token = await AuthStorage.getToken();

    if (token == null) {
      throw Exception('Token not available');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/appointment/?appointment_id=$id'),
      headers: {
        // 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if(response.statusCode !=200) {

      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
    final data =  json.decode(response.body);
    final model = AppointmentModel.fromJson(data);
    return AppointmentMapper.appointmentModeltoEntity(model);
  }
}
