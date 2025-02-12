import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.deepOrange,
      secondary: Colors.deepOrangeAccent,
      surface: Colors.white,
      surfaceTint: Colors.grey[200],
    );
    final themData = ThemeData(
      fontFamily: 'Calibri',
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shadowColor: colorScheme.shadow,
      ),
    );
    return MaterialApp(
      title: 'NTR',
      debugShowCheckedModeBanner: false,
      theme: themData,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nutrition Tracker Recipes'),
        ),
        body: const Center(
          child: Text('Welcome to Nutrition Tracker Recipes'),
        ),
      ),
    );
  }
}
