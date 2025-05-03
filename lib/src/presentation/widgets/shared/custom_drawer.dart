import 'package:agend_app/src/infrastructure/services/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colors.primary),
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              context.go('/home/');
            },
          ),
          Divider(indent: 20, endIndent: 20),
          ListTile(
            leading: const Icon(Icons.circle_notifications),
            title: const Text('Reminders'),
            onTap: () {
              context.go('/appointments/');
              // Navigate to home screen
            },
          ),
          Divider(indent: 20, endIndent: 20),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              try {
                await AuthService.logout(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al cerrar sesión: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
