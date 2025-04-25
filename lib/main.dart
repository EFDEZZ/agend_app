import 'package:agend_app/src/config/router/app_router.dart';
import 'package:agend_app/src/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en', null);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Agend App',
      routerConfig: appRouter,
      theme: AppTheme(selectedColor: 0).getTheme(),
      );
  }
}
