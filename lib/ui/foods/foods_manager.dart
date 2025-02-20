import 'package:flutter/material.dart';
import '../../models/food.dart';

class FoodsManager with ChangeNotifier {
  final List<Food> _items = [
    Food(
      id: 'f1',
      name: 'Apple',
      type: 'Fruit',
      calories: 52,
      protein: 0.3,
      fat: 0.2,
      carbohydrates: 14,
      fiber: 2.4,
      imageUrl: 'assets/foods/apple.jpg',
    ),
    Food(
      id: 'f2',
      name: 'Banana',
      type: 'Fruit',
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
      type: 'Meat',
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
      type: 'Vegetable',
      calories: 55,
      protein: 3.7,
      fat: 0.6,
      carbohydrates: 11,
      fiber: 4,
      imageUrl: 'assets/foods/broccoli.jpg',
    ),
    Food(
      id: 'f5',
      name: 'Salmon',
      type: 'Fish',
      calories: 208,
      protein: 20,
      fat: 13,
      carbohydrates: 0,
      fiber: 0,
      imageUrl: 'assets/foods/salmon.jpg',
    ),
    Food(
      id: 'f6',
      name: 'Beef',
      type: 'Meat',
      calories: 250,
      protein: 26,
      fat: 17,
      carbohydrates: 0,
      fiber: 0,
      imageUrl: 'assets/foods/beef.jpg',
    ),
  ];

  String _selectedType = 'All';

  List<Food> get items {
    if (_selectedType == 'All') {
      return [..._items];
    }
    return _items.where((food) => food.type == _selectedType).toList();
  }

  void setFoodType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  String get selectedType => _selectedType;

  Food? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }
}
