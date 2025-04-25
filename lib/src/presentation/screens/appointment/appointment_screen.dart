import 'package:agend_app/src/presentation/screens/screens.dart';
import 'package:agend_app/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agend_app/src/infrastructure/providers/appointments_provider.dart';

class AppointmentReminder extends ConsumerWidget {
  const AppointmentReminder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(appointmentsProvider);

    return Scaffold(
      drawer: CustomDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _AddAppointmentButton(),
      body: CustomScrollView(
        slivers: [
          CustomSliverAppbar(title: 'Reminders'),
          appointmentsAsync.when(
            data:
                (appointments) => SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    // Si es el último índice, devuelve un SizedBox como padding extra
                    if (index == appointments.length) {
                      return const SizedBox(height: 100);
                    }
                    final appointment = appointments[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      child: Card(
                        elevation: 3,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            //TODO: Agregar funcionalidad AppointmentDetailsView
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment.service,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 5),
                                Text(appointment.note),
                                const SizedBox(height: 10),
                                Text("Date: ${appointment.date}"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }, childCount: appointments.length + 1),
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

class _AddAppointmentButton extends ConsumerWidget {
  const _AddAppointmentButton();

  @override
  Widget build(BuildContext context, ref) {
    return IconButton.filled(
      onPressed: () async {
        final result = await showModalBottomSheet<bool>(
          isScrollControlled: true,
          context: context,
          builder: (context) => const AppointmentRegister(),
        );

        if (result == true && context.mounted) {
          ref.invalidate(appointmentsProvider); // Refresca al guardar
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
