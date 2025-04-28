import 'package:agend_app/src/domain/entities/appointment.dart';
import 'package:agend_app/src/infrastructure/providers/appointment_repository_provider.dart';
import 'package:agend_app/src/infrastructure/repositories/appointment_repository_impl.dart';
import 'package:riverpod/riverpod.dart';

// Create appointment
final appointmentCreateStateNotifierProvider = StateNotifierProvider<
    AppointmentCreateNotifier, AsyncValue<bool>>(
  (ref) {
    final repository = ref.watch(appointmentRepositoryProvider);
    return AppointmentCreateNotifier(ref, repository);
  },
);

class AppointmentCreateNotifier extends StateNotifier<AsyncValue<bool>> {
  final Ref _ref;
  final AppointmentRepositoryImpl _repository;

  AppointmentCreateNotifier(this._ref, this._repository)
      : super(const AsyncData(false));

  Future<bool> createAppointment({
    required DateTime date,
    required String service,
    required String notes,
  }) async {
    state = const AsyncLoading();
    try {
      final success = await _repository.createAppointment(
        date: date,
        service: service,
        notes: notes,
      );

      if (success) {
        _ref.invalidate(appointmentsByUserProvider);
        state = const AsyncData(true);
        return true;
      } else {
        state = AsyncError('Failed to create appointment', StackTrace.current);
        return false;
      }
    } catch (e, st) {
      state = AsyncError(e.toString(), st);
      return false;
    }
  }
}

// Appointments By User
final appointmentsByUserProvider = FutureProvider<List<Appointment>>((ref) async {
  return ref.watch(appointmentRepositoryProvider).getAppointmentsByUser();
});

// All Appointments
final allAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  return ref.watch(appointmentRepositoryProvider).getAllAppointments();
});

// Delete and update appointments
final appointmentDeleteStateNotifierProvider = StateNotifierProvider<
    AppointmentsStateNotifier, AsyncValue<List<Appointment>>>(
  (ref) => AppointmentsStateNotifier(ref),
);

class AppointmentsStateNotifier extends StateNotifier<AsyncValue<List<Appointment>>> {
  final Ref ref;
  AppointmentsStateNotifier(this.ref) : super(const AsyncLoading());

  Future<void> getAppointmentsByUser() async {
    try {
      state = const AsyncLoading();
      final appointments = await ref.watch(appointmentRepositoryProvider).getAppointmentsByUser();
      state = AsyncData(appointments);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteAppointment(int appointmentId) async {
    try {
      state = const AsyncLoading();

      await ref.watch(appointmentRepositoryProvider).deleteAppointment(appointmentId);

      await getAppointmentsByUser();
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
