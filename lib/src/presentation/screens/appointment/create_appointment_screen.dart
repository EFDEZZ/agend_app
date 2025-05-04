import 'package:agend_app/src/infrastructure/providers/appointments_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateAppointmentScreen extends ConsumerStatefulWidget {
  const CreateAppointmentScreen({super.key});

  @override
  CreateAppointmentScreenState createState() => CreateAppointmentScreenState();
}

class CreateAppointmentScreenState extends ConsumerState<CreateAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _submitAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona una fecha')),
        );
      }
      return;
    }

    try {
      final createNotifier = ref.read(appointmentCreateProvider.notifier);
      final success = await createNotifier.createAppointment(
        date: _selectedDate!,
        service: _serviceController.text,
        notes: _notesController.text,
      );

      if (!mounted) return;

      if (success) {
        // Invalida el provider de citas para actualizar la lista
        ref.invalidate(appointmentsProvider);
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la cita')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(appointmentCreateProvider);
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 700,
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "CREAR NUEVA CITA",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Campo de Servicio
              _CustomTextFormField(
                data: "Servicio*",
                controller: _serviceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),

              // Campo de Notas
              _CustomTextFormField(
                data: "Notas",
                height: 150,
                controller: _notesController,
                maxLines: 5,
              ),

              // Selector de Fecha
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Card(
                  color: colors.surface,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      _selectedDate == null
                          ? 'Selecciona una fecha*'
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      style: TextStyle(
                        color: _selectedDate == null ? Colors.grey : colors.onSurface,
                      ),
                    ),
                    trailing: Icon(Icons.calendar_today, color: colors.primary),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        cancelText: 'Cancelar',
                        confirmText: 'Seleccionar',
                        helpText: 'SELECCIONA UNA FECHA',
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: colors.primary,
                                onPrimary: colors.onPrimary,
                                surface: colors.surface,
                                onSurface: colors.onSurface,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: colors.primary,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                  ),
                ),
              ),

              const Spacer(),

              // Botones Inferiores
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: colors.error),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          "CANCELAR",
                          style: TextStyle(
                            fontSize: 16,
                            color: colors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: colors.primary,
                        ),
                        onPressed: createState.isLoading ? null : _submitAppointment,
                        child: createState.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "GUARDAR",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colors.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomTextFormField extends StatelessWidget {
  final String data;
  final double? height;
  final int? maxLines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const _CustomTextFormField({
    required this.data,
    this.height = 80,
    this.maxLines = 1,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: SizedBox(
        height: height,
        child: TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: data,
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.error),
            ),
            contentPadding:  EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines! > 1 ? 16 : 0,
            ),
            errorStyle: TextStyle(color: colors.error, fontSize: 12),
          ),
        ),
      ),
    );
  }
}