
import 'package:agend_app/src/domain/entities/appointment.dart';

abstract class AppointmentRepository {
  Future<bool> createAppointment({required DateTime date, required String service, required String notes});
  Future<List<Appointment>> getAppointmentsByUser();
  Future<List<Appointment>> getAllAppointments();
  Future<void> deleteAppointment(int appointmentId);
  Future<Appointment> getAppointmentDetails(int id);
}