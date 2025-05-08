
class AppointmentModel {
  final DateTime date;
  final String service;
  final String clientPhone;
  final String note;
  final bool reminderSent;
  final DateTime createdAt;
  final int id;

  AppointmentModel({
    required this.date,
    required this.service,
    required this.clientPhone,
    required this.note,
    required this.reminderSent,
    required this.createdAt,
    required this.id,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      date: DateTime.parse(json['date_time']),
      service: json['service'] ?? '',
      clientPhone: json['clientPhone']?.toString() ?? '',
      note: json['notes'] ?? '',
      reminderSent: json['reminder_sent'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      id: json['id'],
    );
  }
}
