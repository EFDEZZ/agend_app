import 'package:agend_app/src/config/helper/is_admin.dart';
import 'package:agend_app/src/domain/entities/appointment.dart';
import 'package:agend_app/src/infrastructure/providers/appointments_providers/appointment_repository_provider.dart';
import 'package:agend_app/src/infrastructure/providers/auth_providers/auth_state_provider.dart';
import 'package:agend_app/src/infrastructure/repositories/appointment_repository_impl.dart';
import 'package:agend_app/src/infrastructure/services/auth_services/auth_storage.dart';
import 'package:riverpod/riverpod.dart';

final previousAppointmentsProvider = StateProvider<List<Appointment>>((ref) => []);
// Provider para el token de autenticación
final authTokenProvider = FutureProvider<String?>((ref) async {
  return AuthStorage.getToken();
});
// Create appointment
final appointmentCreateProvider = StateNotifierProvider<
    AppointmentCreateNotifier, AsyncValue<bool>>(
  (ref) {
    final repository = ref.watch(appointmentRepositoryProvider);
    return AppointmentCreateNotifier(repository);
  },
);

class AppointmentCreateNotifier extends StateNotifier<AsyncValue<bool>> {
  final AppointmentRepositoryImpl _repository;

  AppointmentCreateNotifier(this._repository) : super(const AsyncData(false));

  Future<bool> createAppointment({
    required DateTime date,
    required String service,
    required String phone,
    required String notes,
  }) async {
    state = const AsyncLoading();
    try {
      final success = await _repository.createAppointment(
        date: date,
        service: service,
        notes: notes,
        phone: phone,

      );
      state = AsyncData(success);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

// Get appointments evaluatin the isAdmin paramether
// Provider principal que maneja todas las citas
final cachedAppointmentsProvider = StateProvider<List<Appointment>>((ref) => []);

final appointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final isAuthenticated = ref.watch(authStateProvider).valueOrNull ?? false;
  if (!isAuthenticated) return [];

  final repository = ref.watch(appointmentRepositoryProvider);
  final isAdminUser = await isAdmin();
  
  try {
    final appointments = isAdminUser 
        ? await repository.getAllAppointments()
        : await repository.getAppointmentsByUser();
    
    ref.read(cachedAppointmentsProvider.notifier).state = appointments;
    return appointments;
  } catch (e) {
    // Si hay error, devolver las citas en caché
    return ref.read(cachedAppointmentsProvider);
  }
});



// Appointments By User
final appointmentsByUserProvider = FutureProvider<List<Appointment>>((ref) async {
  return ref.watch(appointmentRepositoryProvider).getAppointmentsByUser();
});

// All Appointments
final allAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  return ref.watch(appointmentRepositoryProvider).getAllAppointments();
});

// Delete and update appointments
final appointmentDeleteProvider = StateNotifierProvider<
    AppointmentDeleteNotifier, AsyncValue<void>>(
  (ref) => AppointmentDeleteNotifier(ref),
);

class AppointmentDeleteNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  AppointmentDeleteNotifier(this.ref) : super(const AsyncData(null));

  Future<void> deleteAppointment(int appointmentId) async {
    state = const AsyncLoading();
    try {
      await ref.read(appointmentRepositoryProvider)
          .deleteAppointment(appointmentId);
      ref.invalidate(appointmentsProvider); // Invalida el provider principal
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

//Get appointment details by id
final appointmentDetailsProvider = FutureProvider.family<Appointment, int>((ref, id) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getAppointmentDetails(id);
});
