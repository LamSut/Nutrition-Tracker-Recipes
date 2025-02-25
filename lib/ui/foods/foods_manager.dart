import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../models/food.dart';

class FoodsManager with ChangeNotifier {
  final List<Food> _items = [
    Food(
      id: 'f1',
      name: 'Apple',
      type: 'Fruits',
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
      type: 'Fruits',
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
      type: 'Proteins',
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
      type: 'Vegetables',
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
      type: 'Proteins',
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
      type: 'Proteins',
      calories: 250,
      protein: 26,
      fat: 17,
      carbohydrates: 0,
      fiber: 0,
      imageUrl: 'assets/foods/beef.jpg',
    ),
    Food(
      id: 'f7',
      name: 'Cheese',
      type: 'Dairy',
      calories: 402,
      protein: 25,
      fat: 33,
      carbohydrates: 1.3,
      fiber: 0,
      imageUrl: 'assets/foods/cheese.jpg',
    ),
  ];

  String _selectedType = 'All';

  List<Food> get items {
    if (_selectedType == 'All') {
      return [..._items];
    }
    return _items.where((food) => food.type == _selectedType).toList();
  }

  List<Food> get allFoods => [..._items];

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

  Future<void> addFood(Food food) async {
    if (food.imageUrl.isEmpty) {
      food = food.copyWith(imageUrl: 'assets/foods/default.jpg');
    } else if (!food.imageUrl.startsWith('assets/foods/')) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(food.imageUrl);
      await File(food.imageUrl).copy('${appDir.path}/$fileName');
      food = food.copyWith(imageUrl: 'assets/foods/$fileName');
    }

    _items.add(
      food.copyWith(
        id: 'f${DateTime.now().toIso8601String()}',
      ),
    );
    notifyListeners();
  }

  Future<void> updateFood(Food food) async {
    final index = _items.indexWhere((item) => item.id == food.id);
    if (index != -1) {
      if (!food.imageUrl.startsWith('assets/foods/')) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = p.basename(food.imageUrl);
        await File(food.imageUrl).copy('${appDir.path}/$fileName');
        food = food.copyWith(imageUrl: 'assets/foods/$fileName');
      }
      _items[index] = food;
      notifyListeners();
    }
  }

  void removeFood(String id) {
    _items.removeWhere((food) => food.id == id);
    notifyListeners();
  }
}
