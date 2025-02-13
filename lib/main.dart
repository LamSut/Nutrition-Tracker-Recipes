import 'package:flutter/material.dart';
import 'ui/screens.dart';

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
      home: const FoodsOverviewScreen(),
      routes: {
        RecipesScreen.routeName: (ctx) => const SafeArea(
              child: RecipesScreen(),
            ),
        SettingsScreen.routeName: (ctx) => const SafeArea(
              child: SettingsScreen(),
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == FoodDetailScreen.routeName) {
          final productId = settings.arguments as String;
          return MaterialPageRoute(
            settings: settings,
            builder: (ctx) {
              return SafeArea(
                child: FoodDetailScreen(
                  FoodsManager().findById(productId)!,
                ),
              );
            },
          );
        }
        return null;
      },
    );
  }
}
