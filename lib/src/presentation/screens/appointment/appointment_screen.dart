import 'package:agend_app/src/presentation/screens/screens.dart';
import 'package:agend_app/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agend_app/src/infrastructure/providers/appointments_provider.dart';
import 'package:go_router/go_router.dart';

class AppointmentScreen extends ConsumerWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final appointmentsAsync = ref.watch(appointmentsByUserProvider);

    return Scaffold(
      drawer: CustomDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _CreateAppointmentButton(),
      body: CustomScrollView(
        slivers: [
          CustomSliverAppbar(title: 'Reminders'),
          appointmentsAsync.when(
            data:
                (appointments) => SliverPadding(
                  padding: const EdgeInsets.only(bottom: 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final appointment = appointments[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 1,
                          vertical: 3,
                        ),
                        child: SizedBox(
                          height: 150,
                          child: Card(
                            elevation: 3,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                //TODO: Agregar funcionalidad AppointmentDetailsView
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  bottom: 20,
                                  left: 15,
                                  right: 5,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            style: TextStyle(
                                              color: const Color.fromARGB(255, 203, 107, 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                  
                                    // Buttons
                                    IconButton(
                                      onPressed: () {
                                        // Aquí agregarías la funcionalidad para enviar recordatorios
                                      },
                                      icon: Icon(
                                        Icons.notifications_none_outlined,
                                        color: colors.primary,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        // Confirmación de eliminación
                                        final confirmDelete = await showDialog<
                                          bool
                                        >(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Delete Appointment',
                                              ),
                                              content: const Text(
                                                'Are you sure you want to delete this appointment?',
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                        255,
                                                        175,
                                                        21,
                                                        10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                  
                                        if (confirmDelete == true) {
                                          // Llamar para eliminar
                                          await ref
                                              .read(
                                                appointmentDeleteStateNotifierProvider
                                                    .notifier,
                                              )
                                              .deleteAppointment(appointment.id);
                  
                                          // Invalidar para refrescar la lista
                                          ref.invalidate(
                                            appointmentsByUserProvider,
                                          );
                  
                                          // No necesitas hacer context.go() ni mounted aquí
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever_outlined,
                                        color: Color.fromARGB(255, 188, 24, 12),
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }, childCount: appointments.length),
                  ),
                ),
            loading:
                () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
            error:
                (error, stack) => SliverFillRemaining(
                  child: Center(child: Text('Error: ${error.toString()}')),
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
  Widget build(BuildContext context, ref) {
    return IconButton.filled(
      onPressed: () async {
        final result = await showModalBottomSheet<bool>(
          isScrollControlled: true,
          context: context,
          builder: (context) => const CreateAppointmentScreen(),
        );

        if (result == true && context.mounted) {
          ref.invalidate(appointmentsByUserProvider); // Refresca al guardar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointment saved successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      icon: const Padding(
        padding: EdgeInsets.all(5.0),
        child: Icon(Icons.add, size: 35),
      ),
    );
  }
}
