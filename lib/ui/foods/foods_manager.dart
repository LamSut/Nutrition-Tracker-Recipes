import '../../models/food.dart';

class FoodsManager {
  final List<Food> _items = [
    Food(
      id: 'f1',
      name: 'Apple',
      calories: 52,
      protein: 0.3,
      fat: 0.2,
      carbohydrates: 14,
      fiber: 2.4,
      imageUrl: 'assets/foods/apple.jpg',
      isFavorite: true,
    ),
    Food(
      id: 'f2',
      name: 'Banana',
      calories: 89,
      protein: 1.1,
      fat: 0.3,
      carbohydrates: 23,
      fiber: 2.6,
      imageUrl: 'assets/foods/banana.jpg',
    ),
    Food(
      id: 'f3',
      name: 'Chicken Breast',
      calories: 165,
      protein: 31,
      fat: 3.6,
      carbohydrates: 0,
      fiber: 0,
      imageUrl: 'assets/foods/chicken-breast.jpg',
    ),
    Food(
      id: 'f4',
      name: 'Broccoli',
      calories: 55,
      protein: 3.7,
      fat: 0.6,
      carbohydrates: 11,
      fiber: 4,
      imageUrl: 'assets/foods/broccoli.jpg',
      isFavorite: true,
    ),
  ];

  int get itemCount {
    return _items.length;
  }

  List<Food> get items {
    return [..._items];
  }

  List<Food> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Food? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }
}
