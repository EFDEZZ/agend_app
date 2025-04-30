import 'package:agend_app/src/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/appointments',
      builder: (context, state) => AppointmentScreen(),
    ),
    GoRoute(
      path: '/appointment',
      builder: (context, state) {
        final idString = state.uri.queryParameters['appointment_id'];
        if (idString == null) {
          throw Exception('Missing appointment_id in query');
        }
        final id = int.tryParse(idString);
        if (id == null) {
          throw Exception('Invalid appointment_id');
        }

        return AppointmentDetailScreen(appointmentId: id);
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
  ],
);
