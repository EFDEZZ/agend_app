import 'package:agend_app/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          CustomSliverAppbar(title: 'HOME'), 
          // Text('Home Screen')
          ],
      ),
    );
  }
}
