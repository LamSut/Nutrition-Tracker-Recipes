import 'dart:io';

class Food {
  final String? id;
  final String name;
  final String type;
  final double calories;
  final double protein;
  final double fat;
  final double carbohydrates;
  final double fiber;
  final File? featuredImage;
  final String imageUrl;

  Food({
    this.id,
    required this.name,
    required this.type,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
    required this.fiber,
    this.featuredImage,
    this.imageUrl = '',
  });

  Food copyWith({
    String? id,
    String? name,
    String? type,
    double? calories,
    double? protein,
    double? fat,
    double? carbohydrates,
    double? fiber,
    File? featuredImage,
    String? imageUrl,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      fiber: fiber ?? this.fiber,
      featuredImage: featuredImage ?? this.featuredImage,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  bool hasFeaturedImage() {
    return featuredImage != null || imageUrl.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbohydrates': carbohydrates,
      'fiber': fiber,
      'imageUrl': imageUrl,
    };
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      carbohydrates: (json['carbohydrates'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
