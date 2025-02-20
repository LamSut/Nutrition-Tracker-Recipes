import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/app_drawer.dart';
import 'foods_grid.dart';
import 'food_search_delegate.dart';
import 'foods_manager.dart';

class FoodsOverviewScreen extends StatelessWidget {
  static const routeName = '/food_overview';

  const FoodsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foodsManager = Provider.of<FoodsManager>(context, listen: false);
    final allFoods = foodsManager.items; // remove filters before search

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Cards'),
        actions: <Widget>[
          const FoodTypeFilterMenu(),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FoodSearchDelegate(allFoods),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: const FoodsGrid(),
    );
  }
}

class FoodTypeFilterMenu extends StatelessWidget {
  const FoodTypeFilterMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final foodsManager = Provider.of<FoodsManager>(context);
    final currentType = foodsManager.selectedType;

    return PopupMenuButton<String>(
      initialValue: currentType,
      onSelected: (type) {
        foodsManager.setFoodType(type);
      },
      icon: const Icon(Icons.more_vert),
      itemBuilder: (ctx) => [
        const PopupMenuItem(value: 'All', child: Text('Show All')),
        const PopupMenuItem(value: 'Fruit', child: Text('Fruits')),
        const PopupMenuItem(value: 'Vegetable', child: Text('Vegetables')),
        const PopupMenuItem(value: 'Meat', child: Text('Meat')),
        const PopupMenuItem(value: 'Fish', child: Text('Fish')),
      ],
    );
  }
}
