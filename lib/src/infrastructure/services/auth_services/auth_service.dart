import 'package:agend_app/src/infrastructure/providers/providers.dart';
import 'package:agend_app/src/infrastructure/services/auth_services/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  static Future<void> logout(BuildContext context, WidgetRef ref) async {
    try {
      // 1. Primero invalidar los providers
      final container = ProviderScope.containerOf(context, listen: false);
      container.invalidate(appointmentsProvider);
      container.invalidate(appointmentsByUserProvider);
      ref.invalidate(appointmentsProvider);
      
      // 2. Luego limpiar el token
      await AuthStorage.clearToken();
      
      // 3. Redirigir al login
      if (context.mounted) {
        context.go('/login');
      }
    } catch (e) {
      throw Exception('Error en logout: $e');
    }
  }
}