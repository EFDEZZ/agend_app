// appointment_animations.dart
import 'package:agend_app/src/presentation/screens/screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agend_app/src/domain/entities/appointment.dart';

class AppointmentListAnimation extends StatefulWidget {
  final List<Appointment> appointments;
  final bool isLoading;

  const AppointmentListAnimation({
    super.key,
    required this.appointments,
    required this.isLoading,
  });

  @override
  State<AppointmentListAnimation> createState() => _AppointmentListAnimationState();
}

class _AppointmentListAnimationState extends State<AppointmentListAnimation> {
  final List<Appointment> _currentAppointments = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentAppointments.addAll(widget.appointments);
  }

  @override
  void didUpdateWidget(covariant AppointmentListAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Solo actualizar si no está cargando y hay cambios
    if (!widget.isLoading && !listEquals(widget.appointments, _currentAppointments)) {
      _currentAppointments
        ..clear()
        ..addAll(widget.appointments);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && _currentAppointments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _currentAppointments.length,
      itemBuilder: (context, index) {
        final appointment = _currentAppointments[index];
        return CustomAppointmentCard(
          appointment: appointment,
          colors: Theme.of(context).colorScheme,
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}