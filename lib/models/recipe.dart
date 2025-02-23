import 'food.dart';

class Recipe {
  final String? id;
  final String name;
  final String description;
  final List<RecipeIngredient> ingredients;
  final String imageUrl;
  final String userID;

  Recipe({
    this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.imageUrl,
    required this.userID,
  });

  Recipe copyWith({
    String? id,
    String? name,
    String? description,
    List<RecipeIngredient>? ingredients,
    String? imageUrl,
    String? userID,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      imageUrl: imageUrl ?? this.imageUrl,
      userID: userID ?? this.userID,
    );
  }
}

class RecipeIngredient {
  final Food food;
  final double quantity;

  RecipeIngredient({
    required this.food,
    required this.quantity,
  });
}
