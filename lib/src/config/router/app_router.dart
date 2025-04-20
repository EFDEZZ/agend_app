import 'package:agend_app/src/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(), 
      ),
    GoRoute(
      path: '/RegisterScreen',
      builder: (context, state) => RegisterScreen(), 
      ),
  ]
);