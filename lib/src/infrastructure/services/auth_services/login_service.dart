import 'dart:convert';

import 'package:agend_app/src/infrastructure/providers/appointments_provider.dart';
import 'package:agend_app/src/infrastructure/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static const String _baseUrl = 'https://ds-appointments-production.up.railway.app';

  Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final token = result['access_token'];

        if (token != null) {
          // 1. Guardar el token primero
          await AuthStorage.saveToken(token);
          
          // 2. Invalidar providers
          final container = ProviderScope.containerOf(context, listen: false);
          container.invalidate(appointmentsProvider);
          
          // 3. Redirigir después de asegurar los datos
          if (context.mounted) {
            await Future.delayed(const Duration(milliseconds: 100)); // Pequeño delay
            context.go('/home');
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      throw Exception('Error en LoginService: $e');
    }
  }
}