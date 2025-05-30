import 'package:agend_app/src/domain/entities/appointment.dart';
import 'package:agend_app/src/infrastructure/models/appointment_model.dart';

class AppointmentMapper {
  static Appointment appointmentModeltoEntity(AppointmentModel model) {
    return Appointment(
      id: model.id,
      date: model.date,
      service: model.service,
      clientPhone: model.clientPhone,
      note: model.note,
      reminderSent: model.reminderSent,
      createdAt: model.createdAt,
    );
  }

  static List<Appointment> toEntityList(List<AppointmentModel> models) {
    return models.map(appointmentModeltoEntity).toList();
  }
}
