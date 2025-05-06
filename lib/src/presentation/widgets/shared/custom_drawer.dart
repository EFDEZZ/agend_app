import 'package:agend_app/src/infrastructure/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          // Header with profile, title, and user name
          SizedBox(
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: colors.onPrimary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // CircleAvatar(
                    //   child: Icon(Icons.account_circle_outlined, size: 40,),
                    // ),
                    const SizedBox(height: 5),
                    // User name (this could be dynamic based on the user data)
                    Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Optional subtitle (like email or role)
                    // Text(
                    //   'user@example.com', // You can replace this with dynamic data
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.white70,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          // Menu items without divider before the first item
          _buildListTile(
            context,
            icon: Icons.home,
            title: 'Home',
            route: '/home/',
            showDivider: true, // No mostrar divider después del primer elemento
          ),
          _buildListTile(
            context,
            icon: Icons.circle_notifications,
            title: 'Reminders',
            route: '/appointments/',
            showDivider: true,
          ),
          _buildListTile(
            context,
            icon: Icons.logout,
            title: 'Logout',
            route: null,
            showDivider: false, // No mostrar divider después del último elemento
            onTap: () async {
              try {
                await AuthService.logout(context, ref);
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

  // Helper method to create a ListTile with proper styling
  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? route,
    bool showDivider = true,
    void Function()? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Theme.of(context).iconTheme.color),
          title: Text(title, style: TextStyle(fontSize: 16)),
          onTap: () {
            if (route != null) {
              context.go(route);
            } else if (onTap != null) {
              onTap();
            }
          },
        ),
        // Mostrar divider solo si showDivider es true y no es el último elemento
        if (showDivider && title != 'Logout') _buildDivider(),
      ],
    );
  }

  // Helper method to add a custom divider with padding
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(),
    );
  }
}