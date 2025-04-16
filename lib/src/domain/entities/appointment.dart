import 'package:intl/intl.dart';

class Appointment {
  final int id;
  final String clientName;
  final String clientPhone;
  final DateTime date;
  final String service;
  final String note;
  final bool reminderSent;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.date,
    required this.service,
    required this.note,
    required this.reminderSent,
    required this.createdAt,
  });
  String get formattedDate => DateFormat('EEE, dd MMM, yyyy', 'en_US').format(date);
  String get formattedTime => DateFormat.jm().format(date);
}

final appointments = <Appointment>[
  Appointment(
    id: 1,
    clientName: "Roberto",
    clientPhone: "58490079",
    date: DateTime.now(),
    service: "Me pica el ano",
    note: "Tengo que arrascarme el ano",
    reminderSent: false,
    createdAt: DateTime(2023),
  ),
  Appointment(
    id: 1,
    clientName: "Roberto",
    clientPhone: "58490079",
    date: DateTime(2024),
    service: "Me pica el ano",
    note: "Tengo que arrascarme el ano",
    reminderSent: false,
    createdAt: DateTime(2023),
  ),
  Appointment(
    id: 1,
    clientName: "Roberto",
    clientPhone: "58490079",
    date: DateTime(2024),
    service: "Me pica el ano",
    note: "Tengo que arrascarme el ano",
    reminderSent: false,
    createdAt: DateTime(2023),
  ),
  Appointment(
    id: 1,
    clientName: "Roberto",
    clientPhone: "58490079",
    date: DateTime(2024),
    service: "Me pica el ano",
    note: "Tengo que arrascarme el ano",
    reminderSent: false,
    createdAt: DateTime(2023),
  ),
  Appointment(
    id: 1,
    clientName: "Roberto",
    clientPhone: "58490079",
    date: DateTime(2024),
    service: "Me pica el ano",
    note: "Tengo que arrascarme el ano",
    reminderSent: false,
    createdAt: DateTime(2023),
  ),
  Appointment(
    id: 1,
    clientName: "Roberto",
    clientPhone: "58490079",
    date: DateTime(2024),
    service: "Me pica el ano",
    note: "Tengo que arrascarme el ano",
    reminderSent: false,
    createdAt: DateTime(2023),
  ),
  Appointment(
    id: 1,
    clientName: "Roberto",
    clientPhone: "58490079",
    date: DateTime(2024),
    service: "Me pica el ano",
    note: "Tengo que arrascarme el ano",
    reminderSent: false,
    createdAt: DateTime(2023),
  ),
  Appointment(
    id: 1,
    clientName: "Roberto",
    clientPhone: "58490079",
    date: DateTime(2024),
    service: "Me pica el ano",
    note: "Tengo que arrascarme el ano",
    reminderSent: false,
    createdAt: DateTime(2023),
  ),
  Appointment(
    id: 1,
    clientName: "Roberto",
    clientPhone: "58490079",
    date: DateTime(2024),
    service: "Me pica el ano",
    note: "Tengo que arrascarme el ano",
    reminderSent: false,
    createdAt: DateTime(2023),
  ),
  Appointment(
    id: 1,
    clientName: "Roberto",
    clientPhone: "58490079",
    date: DateTime(2024),
    service: "Me pica el ano",
    note: "Tengo que arrascarme el ano",
    reminderSent: false,
    createdAt: DateTime(2023),
  ),
  Appointment(
    id: 1,
    clientName: "Roberto",
    clientPhone: "58490079",
    date: DateTime(2024),
    service: "Me pica el ano",
    note: "Tengo que arrascarme el ano",
    reminderSent: false,
    createdAt: DateTime(2023),
  ),
];
