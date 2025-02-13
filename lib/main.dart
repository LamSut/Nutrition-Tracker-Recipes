import 'package:flutter/material.dart';
import 'ui/foods/foods_manager.dart';
import 'ui/foods/food_detail_screen.dart';
import 'ui/foods/foods_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.cyan,
      secondary: Colors.deepOrange,
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
      home: SafeArea(
        child: FoodsOverviewScreen(),
      ),
    );
  }
}
