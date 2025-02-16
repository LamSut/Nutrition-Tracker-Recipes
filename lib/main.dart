import 'package:flutter/material.dart';
import 'ui/screens.dart';
import 'ui/shared/navigation_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.cyan,
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
      initialRoute: LoginScreen.routeName, // Start at LoginScreen
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case LoginScreen.routeName:
            page = const SafeArea(child: LoginScreen());
            break;
          case FoodDetailScreen.routeName:
            final foodId = settings.arguments as String;
            page = SafeArea(
              child: FoodDetailScreen(FoodsManager().findById(foodId)!),
            );
            break;
          case RecipesScreen.routeName:
            page = const SafeArea(child: RecipesScreen());
            break;
          case SettingsScreen.routeName:
            page = const SafeArea(child: SettingsScreen());
            break;
          default:
            page = const SafeArea(child: FoodsOverviewScreen());
            break;
        }
        return createRoute(page);
      },
    );
  }
}
