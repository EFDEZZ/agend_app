import 'package:flutter/material.dart';
import 'package:agend_app/src/domain/entities/appointment.dart';
import 'package:agend_app/src/presentation/screens/screens.dart';

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
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentAppointments.addAll(widget.appointments);
  }

  @override
  void didUpdateWidget(covariant AppointmentListAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (!widget.isLoading) {
      // Elementos nuevos que no estaban antes
      final newItems = widget.appointments.where(
        (item) => !_currentAppointments.any((a) => a.id == item.id)).toList();
      
      // Elementos que han sido eliminados
      final removedItems = _currentAppointments.where(
        (item) => !widget.appointments.any((a) => a.id == item.id)).toList();
      
      // Animación para nuevos elementos (inserción)
      for (var newItem in newItems) {
        final insertionIndex = _findInsertionIndex(newItem);
        _currentAppointments.insert(insertionIndex, newItem);
        _listKey.currentState?.insertItem(
          insertionIndex,
          duration: const Duration(milliseconds: 300),
        );
      }
      
      // Animación para elementos eliminados
      for (var removedItem in removedItems) {
        final removalIndex = _currentAppointments.indexWhere((a) => a.id == removedItem.id);
        if (removalIndex >= 0) {
          final itemToRemove = _currentAppointments[removalIndex];
          _currentAppointments.removeAt(removalIndex);
          _listKey.currentState?.removeItem(
            removalIndex,
            (context, animation) => _buildRemovingItem(itemToRemove, animation),
            duration: const Duration(milliseconds: 250),
          );
        }
      }
    }
  }

  // Encuentra la posición correcta para insertar manteniendo el orden
  int _findInsertionIndex(Appointment newItem) {
    // Aquí puedes implementar tu lógica de ordenación
    // Por ejemplo, ordenar por fecha:
    for (var i = 0; i < _currentAppointments.length; i++) {
      if (newItem.date.isBefore(_currentAppointments[i].date)) {
        return i;
      }
    }
    return _currentAppointments.length;
  }

  // Widget para la animación de eliminación
  Widget _buildRemovingItem(Appointment item, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
        axisAlignment: 0.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: CustomAppointmentCard(
            appointment: item,
            colors: Theme.of(context).colorScheme,
          ),
        ),
      ),
    );
  }

  // Widget para la animación de inserción
  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    final appointment = _currentAppointments[index];
    
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuart,
      )),
      child: FadeTransition(
        opacity: animation,
        child: CustomAppointmentCard(
          appointment: appointment,
          colors: Theme.of(context).colorScheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && _currentAppointments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return AnimatedList(
      key: _listKey,
      controller: _scrollController,
      initialItemCount: _currentAppointments.length,
      itemBuilder: (context, index, animation) {
        return _buildItem(context, index, animation);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}