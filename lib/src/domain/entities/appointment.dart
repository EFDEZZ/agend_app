import 'package:intl/intl.dart';

class Appointment {
  final DateTime date;
  final String service;
  final String clientPhone;
  final String note;
  final bool reminderSent;
  final DateTime createdAt;
  final int id;

  Appointment({
    required this.date,
    required this.service,
    required this.clientPhone,
    required this.note,
    required this.reminderSent,
    required this.createdAt,
    required this.id,
  });
  String get formattedDate => DateFormat('EEE, dd MMM, yyyy', 'en_US').format(date);
  String get formattedTime => DateFormat.jm().format(date);
}