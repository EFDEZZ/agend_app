import 'package:intl/intl.dart';

class Appointment {
  final DateTime date;
  final String service;
  final String note;
  final bool reminderSent;
  final DateTime createdAt;

  Appointment({
    required this.date,
    required this.service,
    required this.note,
    required this.reminderSent,
    required this.createdAt,
  });
  String get formattedDate => DateFormat('EEE, dd MMM, yyyy', 'en_US').format(date);
  String get formattedTime => DateFormat.jm().format(date);
}