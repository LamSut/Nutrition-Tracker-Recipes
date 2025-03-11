import 'dart:io';
import 'food.dart';

class Recipe {
  final String? id;
  final String name;
  final String description;
  final List<RecipeIngredient> ingredients;
  final File? featuredImage;
  final String imageUrl;
  final String userId;

  Recipe({
    this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    this.featuredImage,
    this.imageUrl = '',
    required this.userId,
  });

  Recipe copyWith({
    String? id,
    String? name,
    String? description,
    List<RecipeIngredient>? ingredients,
    File? featuredImage,
    String? imageUrl,
    String? userId,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      featuredImage: featuredImage ?? this.featuredImage,
      imageUrl: imageUrl ?? this.imageUrl,
      userId: userId ?? this.userId,
    );
  }

  bool hasFeaturedImage() {
    return featuredImage != null || imageUrl.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'userId': userId,
      'ingredients':
          ingredients.map((ingredient) => ingredient.toJson()).toList(),
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => RecipeIngredient.fromJson(e))
          .toList(),
      imageUrl: json['imageUrl'] ?? '',
      userId: json['userId'],
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

  Map<String, dynamic> toJson() {
    return {
      'food': food.toJson(),
      'quantity': quantity,
    };
  }

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      food: Food.fromJson(json['food']),
      quantity: (json['quantity'] as num).toDouble(),
    );
  }
}
