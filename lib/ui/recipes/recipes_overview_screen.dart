import 'package:flutter/material.dart';
import '../shared/app_drawer.dart';

class RecipesScreen extends StatelessWidget {
  static const routeName = '/recipes';
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Screen'),
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text('This is a blank screen'),
      ),
    );
  }
}
