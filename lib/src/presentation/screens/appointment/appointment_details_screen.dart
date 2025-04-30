import 'package:agend_app/src/infrastructure/providers/appointments_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppointmentDetailScreen extends ConsumerWidget {
  final int appointmentId;

  const AppointmentDetailScreen({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentAsync = ref.watch(appointmentDetailsProvider(appointmentId));

    return Scaffold(
      appBar: AppBar(title: const Text("Appointment Details")),
      body: appointmentAsync.when(
        data: (appointment) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Service: ${appointment.service}", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text("Note: ${appointment.note}"),
              const SizedBox(height: 10),
              Text("Date: ${appointment.formattedDate}"),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: ${e.toString()}")),
      ),
    );
  }
}
