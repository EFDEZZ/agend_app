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
      appBar: AppBar(
        title: const Text("Appointment Details"),
        centerTitle: true,
      ),
      body: appointmentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: ${e.toString()}")),
        data: (appointment) {
          final dateFormatted = appointment.formattedDate;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _InfoCard(
                  leading: Icons.design_services,
                  trailing: Icons.edit,
                  title: 'Service',
                  content: appointment.service,
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  leading: Icons.phone_android_outlined,
                  trailing: Icons.edit,
                  title: 'Client Phone',
                  content: appointment.clientPhone,
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  leading: Icons.notes,
                  trailing: Icons.edit,
                  title: 'Notes',
                  content: appointment.note,
                  isScrollable: true, // Pass the scrollable flag
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  leading: Icons.calendar_today,
                  trailing: Icons.edit,
                  title: 'Date',
                  content: dateFormatted,
                ),
                const SizedBox(height: 16),
                // _InfoCard(
                //   leading: Icons.notifications_active,
                //   title: 'Reminder Sent',
                //   content: appointment.reminderSent ? 'Yes' : 'No',
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData leading;
  final IconData? trailing;
  final String title;
  final String content;
  final bool isScrollable;

  const _InfoCard({
    required this.leading,
    this.trailing,
    required this.title,
    required this.content,
    this.isScrollable = false, // Optional parameter to make it scrollable
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(leading, size: 32, color: colorScheme.primary),
        trailing: Icon(trailing, size: 28, color: colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: isScrollable
            ? Container(
                constraints: BoxConstraints(maxHeight: 300), // Max height for scrollable area
                child: SingleChildScrollView(
                  child: Text(content),
                ),
              )
            : Text(content, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
