import 'package:flutter/foundation.dart';
import '../../models/recipe.dart';
import '../../services/recipes_service.dart';

class RecipesManager with ChangeNotifier {
  final RecipesService _recipesService = RecipesService();
  List<Recipe> _items = [];

  int get itemCount => _items.length;

  List<Recipe> get items => [..._items];

  Recipe? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  Future<void> fetchRecipes({bool filteredByUser = false}) async {
    _items = await _recipesService.fetchRecipes(filteredByUser: filteredByUser);
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    final newRecipe = await _recipesService.addRecipe(recipe);
    if (newRecipe != null) {
      _items.add(newRecipe);
      notifyListeners();
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final index = _items.indexWhere((item) => item.id == recipe.id);
    if (index >= 0) {
      final updatedRecipe = await _recipesService.updateRecipe(recipe);
      if (updatedRecipe != null) {
        _items[index] = updatedRecipe;
        notifyListeners();
      }
    }
  }

  Future<void> deleteRecipe(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0 && await _recipesService.deleteRecipe(id)) {
      _items.removeAt(index);
      notifyListeners();
    }
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
