import 'package:agend_app/src/domain/entities/appointment.dart';
import 'package:agend_app/src/infrastructure/providers/auth_providers/auth_state_provider.dart';
import 'package:agend_app/src/presentation/animations/animations.dart';
import 'package:agend_app/src/presentation/screens/screens.dart';
import 'package:agend_app/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agend_app/src/infrastructure/providers/appointments_providers/appointments_provider.dart';
import 'package:go_router/go_router.dart';

class AppointmentScreen extends ConsumerWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final appointmentsState = ref.watch(appointmentsProvider);
    final cachedAppointments = ref.watch(cachedAppointmentsProvider);

    return Scaffold(
      drawer: CustomDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _CreateAppointmentButton(),
      appBar: AppBar(
        title: const Text(
          "Reminders",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (isAuthenticated) {
          if (!isAuthenticated) {
            return const Center(
              child: Text('Please login to view appointments'),
            );
          }

          final displayAppointments = appointmentsState.maybeWhen(
            data: (appts) => appts,
            orElse: () => cachedAppointments,
          );

          if (displayAppointments.isEmpty && !appointmentsState.isLoading) {
            return const Center(child: Text('No appointments found.'));
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(appointmentsProvider.future),
            child: AppointmentListAnimation(
              key: ValueKey(isAuthenticated),
              appointments: displayAppointments,
              isLoading: appointmentsState.isLoading,
            ),
          );
        },
      ),
    );
  }
}

// Clases CustomAppointmentCard, _CreateAppointmentButton y showCustomSnackbar
// permanecen exactamente igual que en tu código original

class CustomAppointmentCard extends ConsumerWidget {
  const CustomAppointmentCard({
    super.key,
    required this.appointment,
    required this.colors,
  });

  final Appointment appointment;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 3),
      child: SizedBox(
        height: 150,
        child: Card(
          elevation: 3,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              context.push('/appointment?appointment_id=${appointment.id}');
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.service,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          appointment.note,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Date: ${appointment.formattedDate}",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 203, 107, 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Acción de notificación
                    },
                    icon: Icon(
                      Icons.notifications_none_outlined,
                      color: colors.primary,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final confirm = await _showDeleteConfirmationDialog(
                        context,
                      );
                      if (confirm == true) {
                        await ref
                            .read(appointmentDeleteProvider.notifier)
                            .deleteAppointment(appointment.id);
                        // No necesitas invalidar manualmente, el notifier ya lo hace
                      }
                    },
                    icon: const Icon(
                      Icons.delete_forever_outlined,
                      color: Color.fromARGB(255, 174, 21, 10),
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Appointment'),
            content: const Text(
              'Are you sure you want to delete this appointment?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Color.fromARGB(255, 175, 21, 10)),
                ),
              ),
            ],
          ),
    );
  }
}

class _CreateAppointmentButton extends ConsumerWidget {
  const _CreateAppointmentButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Center(
        child: GestureDetector(
          onTap: () async {
            final result = await showModalBottomSheet<bool>(
              isScrollControlled: true,
              context: context,
              builder: (context) => const CreateAppointmentScreen(),
            );
            if (result == true && context.mounted) {
              showCustomSnackbar(context, 'Appointment saved successfully');
            }
          },
          child: RippleAnimation(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

void showCustomSnackbar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder:
        (context) => Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            top: false,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
