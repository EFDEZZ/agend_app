
import 'package:agend_app/src/infrastructure/datasources/appointment_api_datasource.dart';
import 'package:agend_app/src/infrastructure/repositories/appointment_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appointmentRepositoryProvider = Provider((ref) {
  return AppointmentRepositoryImpl(datasource: AppointmentAPIDatasource());
},);