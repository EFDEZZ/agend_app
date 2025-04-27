import 'package:agend_app/src/domain/entities/appointment.dart';
import 'package:agend_app/src/infrastructure/providers/appointment_repository_provider.dart';
import 'package:riverpod/riverpod.dart';

//Appointments By User
final appointmentsByUserProvider = FutureProvider<List<Appointment>>((
  ref,
) async {
  return ref.watch(appointmentRepositoryProvider).getAppointmentsByUser();
});

//All Appointments 
final allAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  return ref.watch(appointmentRepositoryProvider).getAllAppointments();
});

//Delete and update appointments
final appointmentDeleteStateNotifierProvider = StateNotifierProvider<
  AppointmentsStateNotifier,
  AsyncValue<List<Appointment>>
>((ref) => AppointmentsStateNotifier(ref));

class AppointmentsStateNotifier extends StateNotifier<AsyncValue<List<Appointment>>> {
  final Ref ref;
  AppointmentsStateNotifier(this.ref) : super(const AsyncLoading());

  Future<void> getAppointmentsByUser() async {
    try {
      state = const AsyncLoading();
      final appointments = await ref.watch(appointmentRepositoryProvider).getAppointmentsByUser();
      state = AsyncData(appointments);
    } catch (e, stack) {
      state = AsyncError(e, stack); // Pasamos ambos parámetros: el error y el stack trace
    }
  }

  Future<void> deleteAppointment(int appointmentId) async {
    try {
      state = const AsyncLoading();  // Indicamos que estamos cargando

      // Eliminar la cita
      await ref.watch(appointmentRepositoryProvider).deleteAppointment(appointmentId);

      // Volver a cargar las citas después de la eliminación
      await getAppointmentsByUser();
    } catch (e, stack) {
      state = AsyncError(e, stack); // Pasamos ambos parámetros: el error y el stack trace
    }
  }
}

