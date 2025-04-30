import 'package:agend_app/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      drawer: CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/img/logo.jpg',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Welcome to Remodeling DS LLC',
                      style: theme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.primary
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your trusted partner in scheduling professional home remodeling and restoration services.',
                      style: theme.bodyLarge?.copyWith(
                        color: colors.onSurface
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
