import 'package:agend_app/src/domain/datasources/appointment_datasource.dart';
import 'package:agend_app/src/domain/entities/appointment.dart';
import 'package:agend_app/src/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl extends AppointmentRepository{
  final AppointmentDatasource datasource;

  AppointmentRepositoryImpl({required this.datasource});

  @override
  Future<bool> createAppointment({required DateTime date, required String service, required String notes}) {
    return datasource.createAppointment(date: date, service: service, notes: notes);
  }


  @override
  Future<List<Appointment>> getAllAppointments() {
    return datasource.getAllAppointments();
  }

  @override
  Future<List<Appointment>> getAppointmentsByUser() {
    return datasource.getAppointmentsByUser();
  }
  
  @override
  Future<void> deleteAppointment(int appointmentId) {
    return datasource.deleteAppointment(appointmentId);
  }
  
  @override
  Future<Appointment> getAppointmentDetails(int id) {
    return datasource.getAppointmentDetails(id);
  }
  
}