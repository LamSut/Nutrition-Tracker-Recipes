class Food {
  final String? id;
  final String name;
  final String type;
  final double calories;
  final double protein;
  final double fat;
  final double carbohydrates;
  final double fiber;
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
    required this.imageUrl,
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
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
