import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../foods/foods_manager.dart';

class RecipesManager with ChangeNotifier {
  final List<Recipe> _items = [];
  final FoodsManager _foodsManager;

  RecipesManager(this._foodsManager) {
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

  void addRecipe(Recipe recipe) {
    _items.add(recipe);
    notifyListeners();
  }

  void updateRecipe(String id, Recipe updatedRecipe) {
    final index = _items.indexWhere((recipe) => recipe.id == id);
    if (index != -1) {
      _items[index] = updatedRecipe;
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

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'fat': totalFat,
      'carbohydrates': totalCarbohydrates,
      'fiber': totalFiber,
    };
  }
}
