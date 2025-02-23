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
              'A delicious Portuguese-style beef dish with a hint of apple.',
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

  void addRecipe(Recipe recipe) {
    _items.add(recipe);
    notifyListeners();
  }

  void removeRecipe(String id) {
    _items.removeWhere((recipe) => recipe.id == id);
    notifyListeners();
  }

  void modifyRecipe(String id, Recipe updatedRecipe) {
    final index = _items.indexWhere((recipe) => recipe.id == id);
    if (index != -1) {
      _items[index] = updatedRecipe;
      notifyListeners();
    }
  }
}
