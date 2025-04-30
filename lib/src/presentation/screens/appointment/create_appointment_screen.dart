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
  bool _isLoading = false;

  Future<void> _submitAppointment() async {
  if (!_formKey.currentState!.validate()) return;

  if (_selectedDate == null) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a date')));
    }
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final appointmentCreateNotifier = ref.read(
      appointmentCreateStateNotifierProvider.notifier,
    );

    final success = await appointmentCreateNotifier.createAppointment(
      date: _selectedDate!,
      service: _serviceController.text,
      notes: _notesController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save appointment')),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
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
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 700,
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text("BOOK APPOINTMENT", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              _CustomTextFormField(
                data: "Service",
                controller: _serviceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a service';
                  }
                  return null;
                },
              ),

              _CustomTextFormField(
                data: "Notes",
                height: 200,
                controller: _notesController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a note';
                  }
                  return null;
                },
                maxLines: 5,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      _selectedDate == null
                          ? 'Select a date'
                          : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      style: TextStyle(
                        color:
                            _selectedDate == null ? Colors.grey : colors.secondary,
                      ),
                    ),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        cancelText: 'Cancel',
                        confirmText: 'Select',
                        helpText: 'Select a date',
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
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : TextButton(
                          onPressed: _submitAppointment,
                          child: const Text(
                            "Save",
                            style: TextStyle(fontSize: 20, color: Colors.blue),
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
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
        child: Card(
          color: colors.surface,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: controller,
              validator: validator,
              maxLines: maxLines,
              decoration: InputDecoration(
                alignLabelWithHint: false,
                border: InputBorder.none,
                hintText: data,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                errorStyle: const TextStyle(fontSize: 12, height: 0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
