import 'package:flutter/material.dart';
import '../shared/app_drawer.dart';

class UserScreen extends StatelessWidget {
  static const routeName = '/user_profile';
  const UserScreen({super.key});

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
