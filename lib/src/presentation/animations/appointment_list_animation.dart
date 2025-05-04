// appointment_animations.dart
import 'package:agend_app/src/presentation/screens/screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agend_app/src/domain/entities/appointment.dart';

class AppointmentListAnimation extends StatefulWidget {
  final List<Appointment> appointments;

  const AppointmentListAnimation({super.key, required this.appointments});

  @override
  State<AppointmentListAnimation> createState() => _AppointmentListAnimationState();
}

class _AppointmentListAnimationState extends State<AppointmentListAnimation> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<Appointment> _items;

  @override
  void initState() {
    super.initState();
    _items = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < widget.appointments.length; i++) {
        _items.add(widget.appointments[i]);
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  @override
void didUpdateWidget(covariant AppointmentListAnimation oldWidget) {
  super.didUpdateWidget(oldWidget);

  final oldIds = oldWidget.appointments.map((e) => e.id).toSet();
  final newIds = widget.appointments.map((e) => e.id).toSet();

  // 🔁 Si la lista cambió completamente, reinicia animadamente
  if (!setEquals(oldIds, newIds)) {
    for (int i = _items.length - 1; i >= 0; i--) {
      final removedItem = _items.removeAt(i);
      _listKey.currentState?.removeItem(
        i,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: CustomAppointmentCard(
            appointment: removedItem,
            colors: Theme.of(context).colorScheme,
          ),
        ),
        duration: const Duration(milliseconds: 300),
      );
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      for (int i = 0; i < widget.appointments.length; i++) {
        _items.insert(i, widget.appointments[i]);
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 300),
        );
      }
    });

    return;
  }

  // 👇 Aquí sigue tu lógica actual si solo hay pequeñas diferencias
  for (int i = 0; i < _items.length; i++) {
    if (!newIds.contains(_items[i].id)) {
      final removedItem = _items.removeAt(i);
      _listKey.currentState?.removeItem(
        i,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: CustomAppointmentCard(
            appointment: removedItem,
            colors: Theme.of(context).colorScheme,
          ),
        ),
        duration: const Duration(milliseconds: 300),
      );
      break;
    }
  }

  for (int i = 0; i < widget.appointments.length; i++) {
    if (!_items.any((a) => a.id == widget.appointments[i].id)) {
      _items.insert(i, widget.appointments[i]);
      _listKey.currentState?.insertItem(
        i,
        duration: const Duration(milliseconds: 300),
      );
      break;
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index, animation) {
          final appointment = _items[index];
          return SizeTransition(
            sizeFactor: animation,
            child: CustomAppointmentCard(
              appointment: appointment,
              colors: colors,
            ),
          );
        },
      ),
    );
  }
}
