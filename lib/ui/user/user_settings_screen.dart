import 'package:flutter/material.dart';
import '../shared/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({super.key});

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
