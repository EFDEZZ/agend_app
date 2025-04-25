
import 'package:agend_app/src/infrastructure/models/appointment_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:riverpod/riverpod.dart';

import '../services/services.dart';

final appointmentsProvider = FutureProvider<List<AppointmentModel>>((ref) async {
  final token = await AuthStorage.getToken();

  if (token == null) throw Exception('Token no encontrado');

  final response = await http.get(
    Uri.parse('https://ds-appointments-production.up.railway.app/appointments'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((e) => AppointmentModel.fromJson(e)).toList();
  } else {
    throw Exception('Error al obtener las citas');
  }
});
