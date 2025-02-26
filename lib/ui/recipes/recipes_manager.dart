import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../foods/foods_manager.dart';
import '../user/users_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class RecipesManager with ChangeNotifier {
  List<Recipe> _items = [];
  final FoodsManager _foodsManager;
  final UsersManager _usersManager;

  RecipesManager(this._foodsManager, this._usersManager) {
    _initializeRecipes();
  }

  void _initializeRecipes() {
    final beef = _foodsManager.findById('f6');
    final apple = _foodsManager.findById('f1');

    if (beef != null && apple != null) {
      _items.add(
        Recipe(
          id: 'r1',
          name: 'Portuguese Style Beef',
          description:
              'A flavorful Portuguese-style dish that combines tender beef with the natural sweetness of apples, enhanced by aromatic spices and traditional Portuguese seasonings.',
          ingredients: [
            RecipeIngredient(food: beef, quantity: 2.0),
            RecipeIngredient(food: apple, quantity: 0.5),
          ],
          imageUrl: 'assets/recipes/portuguese-style-beef.png',
          userID: 'u1',
        ),
      );
    }
  }

  List<Recipe> get items => [..._items];

  List<Recipe> get userRecipes {
    final user = _usersManager.loggedInUser;
    return user != null
        ? _items.where((r) => r.userID == user.id).toList()
        : [];
  }

  Recipe findById(String id) {
    return _items.firstWhere(
      (recipe) => recipe.id == id,
      orElse: () => Recipe(
        id: 'unknown',
        name: 'Unknown Recipe',
        description: 'No recipe found.',
        ingredients: [],
        imageUrl: '',
        userID: '',
      ),
    );
  }

  Future<void> addRecipe(Recipe recipe) async {
    final user = _usersManager.loggedInUser;
    if (user == null) {
      throw Exception('User must be logged in to add a recipe.');
    }

    String imageUrl = recipe.imageUrl.isEmpty
        ? 'assets/recipes/default.jpg'
        : recipe.imageUrl;

    if (!imageUrl.startsWith('assets/recipes/')) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(imageUrl);
      await File(imageUrl).copy('${appDir.path}/$fileName');
      imageUrl = 'assets/recipes/$fileName';
    }

    final newRecipe = Recipe(
      id: 'r${DateTime.now().toIso8601String()}',
      name: recipe.name,
      description: recipe.description,
      ingredients: recipe.ingredients,
      imageUrl: imageUrl,
      userID: user.id!,
    );

    _items.add(newRecipe);
    notifyListeners();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final index = _items.indexWhere((item) => item.id == recipe.id);
    if (index != -1) {
      if (!recipe.imageUrl.startsWith('assets/recipes/')) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = p.basename(recipe.imageUrl);
        await File(recipe.imageUrl).copy('${appDir.path}/$fileName');
        recipe = recipe.copyWith(imageUrl: 'assets/recipes/$fileName');
      }
      _items[index] = recipe;
      notifyListeners();
    }
  }

  void removeRecipe(String id) {
    _items.removeWhere((recipe) => recipe.id == id);
    notifyListeners();
  }

  Map<String, double> calculateTotalNutrition(Recipe recipe) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalFat = 0;
    double totalCarbohydrates = 0;
    double totalFiber = 0;

    for (var ingredient in recipe.ingredients) {
      totalCalories += ingredient.food.calories * ingredient.quantity;
      totalProtein += ingredient.food.protein * ingredient.quantity;
      totalFat += ingredient.food.fat * ingredient.quantity;
      totalCarbohydrates += ingredient.food.carbohydrates * ingredient.quantity;
      totalFiber += ingredient.food.fiber * ingredient.quantity;
    }

    double roundTo2Decimals(double value) {
      return double.parse(value.toStringAsFixed(2));
    }

    return {
      'calories': roundTo2Decimals(totalCalories),
      'protein': roundTo2Decimals(totalProtein),
      'fat': roundTo2Decimals(totalFat),
      'carbohydrates': roundTo2Decimals(totalCarbohydrates),
      'fiber': roundTo2Decimals(totalFiber),
    };
  }
}
