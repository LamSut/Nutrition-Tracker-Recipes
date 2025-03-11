import 'package:flutter/foundation.dart';
import '../../models/food.dart';
import '../../services/foods_service.dart';

class FoodsManager with ChangeNotifier {
  final FoodsService _foodsService = FoodsService();
  List<Food> _items = [];
  String _selectedType = 'All';

  int get itemCount => _items.length;

  List<Food> get allFoods => [..._items];

  List<Food> get items {
    if (_selectedType == 'All') {
      return [..._items];
    }
    return _items.where((food) => food.type == _selectedType).toList();
  }

  String get selectedType => _selectedType;

  void setFoodType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  Food? findById(String id) {
    try {
      return _items.firstWhere((food) => food.id == id);
    } catch (error) {
      return null;
    }
  }

  Future<void> fetchFoods() async {
    _items = await _foodsService.fetchFoods();
    notifyListeners();
  }

  Future<void> addFood(Food food) async {
    final newFood = await _foodsService.addFood(food);
    if (newFood != null) {
      _items.add(newFood);
      notifyListeners();
    }
  }

  Future<void> updateFood(Food food) async {
    final index = _items.indexWhere((item) => item.id == food.id);
    if (index >= 0) {
      final updatedFood = await _foodsService.updateFood(food);
      if (updatedFood != null) {
        _items[index] = updatedFood;
        notifyListeners();
      }
    }
  }

  Future<void> deleteFood(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0 && await _foodsService.deleteFood(id)) {
      _items.removeAt(index);
      notifyListeners();
    }
  }
}
