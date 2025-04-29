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
  ]
);