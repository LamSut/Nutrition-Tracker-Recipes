class Food {
  final String? id;
  final String name;
  final double calories;
  final double protein;
  final double fat;
  final double carbohydrates;
  final double fiber;
  final String imageUrl;
  final bool isFavorite;

  Food({
    this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
    required this.fiber,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Food copyWith({
    String? id,
    String? name,
    double? calories,
    double? protein,
    double? fat,
    double? carbohydrates,
    double? fiber,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      fiber: fiber ?? this.fiber,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
