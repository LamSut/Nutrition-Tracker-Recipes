import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/screens.dart';
import 'ui/shared/navigation_utils.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => UsersManager()),
        ChangeNotifierProvider(create: (ctx) => FoodsManager()),
        ChangeNotifierProvider(
            create: (ctx) =>
                RecipesManager(Provider.of<FoodsManager>(ctx, listen: false))),
      ],
      child: const MyApp(),
    ),
  );
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

    final themeData = ThemeData(
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
      theme: themeData,
      initialRoute: LoginScreen.routeName,
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case LoginScreen.routeName:
            page = const SafeArea(child: LoginScreen());
            break;
          case FoodDetailScreen.routeName:
            final productId = settings.arguments as String;
            page = SafeArea(
              child: Consumer<FoodsManager>(
                builder: (context, foodsManager, _) => FoodDetailScreen(
                  foodsManager.findById(productId)!,
                ),
              ),
            );
            break;
          case RecipeDetailScreen.routeName:
            final recipeId = settings.arguments as String;
            page = SafeArea(
              child: Consumer<RecipesManager>(
                builder: (context, recipesManager, _) => RecipeDetailScreen(
                  recipesManager.findById(recipeId),
                ),
              ),
            );
            break;
          case RecipesScreen.routeName:
            page = const SafeArea(child: RecipesScreen());
            break;
          case UserScreen.routeName:
            page = const SafeArea(child: UserScreen());
            break;
          case UserUpdateInformationScreen.routeName:
            page = const SafeArea(child: UserUpdateInformationScreen());
            break;
          case UserUpdatePasswordScreen.routeName:
            page = const SafeArea(child: UserUpdatePasswordScreen());
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
