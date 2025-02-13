import 'package:flutter/material.dart';
import '../foods/foods_overview_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, FoodsOverviewScreen.routeName);
          },
          child: const Text('Go to Foods Overview'),
        ),
      ),
    );
  }
}
