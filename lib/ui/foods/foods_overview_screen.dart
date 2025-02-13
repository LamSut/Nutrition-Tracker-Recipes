import 'package:flutter/material.dart';
import 'foods_grid.dart';
import 'food_search_delegate.dart';
import 'foods_manager.dart';
import '../shared/app_drawer.dart';

enum FilterOptions { favorites, all }

class FoodsOverviewScreen extends StatefulWidget {
  static const routeName = '/food_overview';
  const FoodsOverviewScreen({super.key});
  @override
  State<FoodsOverviewScreen> createState() => FoodsOverviewScreenState();
}

class FoodsOverviewScreenState extends State<FoodsOverviewScreen> {
  var _currentFilter = FilterOptions.all;
  @override
  Widget build(BuildContext context) {
    final foodsManager = FoodsManager();
    final allFoods = foodsManager.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NTR'),
        actions: <Widget>[
          FoodFilterMenu(
            currentFilter: _currentFilter,
            onFilterSelected: (filter) {
              setState(() {
                _currentFilter = filter;
              });
            },
          ),
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
      body: FoodsGrid(
        _currentFilter == FilterOptions.favorites,
      ),
    );
  }
}

class FoodFilterMenu extends StatelessWidget {
  const FoodFilterMenu({
    super.key,
    this.currentFilter,
    this.onFilterSelected,
  });
  final FilterOptions? currentFilter;
  final void Function(FilterOptions selectedValue)? onFilterSelected;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      initialValue: currentFilter,
      onSelected: onFilterSelected,
      icon: const Icon(Icons.more_vert),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Only Favorites'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Show All'),
        ),
      ],
    );
  }
}
