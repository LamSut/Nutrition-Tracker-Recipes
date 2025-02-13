import 'package:flutter/material.dart';
import 'foods_grid.dart';
import '../../models/food.dart';
import 'food_detail_screen.dart';
import 'foods_manager.dart';

enum FilterOptions { favorites, all }

class FoodsOverviewScreen extends StatefulWidget {
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
        title: const Text('Nutrition Tracker Recipes'),
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

class FoodSearchDelegate extends SearchDelegate<String> {
  final List<Food> allFoods;

  FoodSearchDelegate(this.allFoods);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Food> filteredFoods = allFoods
        .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (filteredFoods.isEmpty) {
      return Center(child: Text("No results found for \"$query\""));
    }

    return ListView.builder(
      itemCount: filteredFoods.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          title: Text(filteredFoods[index].name),
          leading: Image.asset(filteredFoods[index].imageUrl,
              width: 70, height: 70, fit: BoxFit.cover),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => FoodDetailScreen(filteredFoods[index]),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
