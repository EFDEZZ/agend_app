class AppointmentModel {
  final DateTime date;
  final String service;
  final String note;
  final bool reminderSent;
  final DateTime createdAt;

  AppointmentModel({
    required this.date,
    required this.service,
    required this.note,
    required this.reminderSent,
    required this.createdAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      date: DateTime.parse(json['date_time']),
      service: json['service'] ?? '',
      note: json['notes'] ?? '',
      reminderSent: json['reminder_sent'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
