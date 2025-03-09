import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'ui/screens.dart';
import 'ui/shared/navigation_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => UserManager()),
        ChangeNotifierProvider(create: (ctx) => FoodsManager()),
        ChangeNotifierProvider(
          create: (ctx) => RecipesManager(
            Provider.of<FoodsManager>(ctx, listen: false),
            Provider.of<UserManager>(ctx, listen: false),
          ),
        ),
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
      seedColor: Colors.teal,
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
      home: Consumer<UserManager>(
        builder: (ctx, usersManager, child) {
          if (usersManager.isAuth) {
            return const SafeArea(child: FoodsOverviewScreen());
          } else {
            return FutureBuilder(
              future: usersManager.tryAutoLogin(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const SafeArea(child: UserAuthScreen());
                }
              },
            );
          }
        },
      ),
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case FoodDetailScreen.routeName:
            final foodId = settings.arguments as String;
            page = SafeArea(
              child: Consumer<FoodsManager>(
                builder: (context, foodsManager, _) => FoodDetailScreen(
                  foodsManager.findById(foodId)!,
                ),
              ),
            );
            break;
          case FoodEditScreen.routeName:
            final foodId = settings.arguments as String?;
            page = SafeArea(
              child: Consumer<FoodsManager>(
                builder: (context, foodsManager, _) => FoodEditScreen(
                  food: foodId != null ? foodsManager.findById(foodId) : null,
                ),
              ),
            );
            break;
          case RecipesOverviewScreen.routeName:
            page = const SafeArea(child: RecipesOverviewScreen());
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
          case RecipeEditScreen.routeName:
            final recipeId = settings.arguments as String?;
            page = SafeArea(
              child: Consumer<RecipesManager>(
                builder: (context, recipesManager, _) => RecipeEditScreen(
                  recipe: recipeId != null
                      ? recipesManager.findById(recipeId)
                      : null,
                ),
              ),
            );
            break;
          // case UserProfileScreen.routeName:
          //   page = const SafeArea(child: UserProfileScreen());
          //   break;
          // case UserUpdateInformationScreen.routeName:
          //   page = const SafeArea(child: UserUpdateInformationScreen());
          //   break;
          // case UserUpdatePasswordScreen.routeName:
          //   page = const SafeArea(child: UserUpdatePasswordScreen());
          //   break;
          default:
            page = const SafeArea(child: FoodsOverviewScreen());
            break;
        }
        return createRoute(page); // slide transition animation
      },
    );
  }
}
