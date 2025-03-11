import 'package:flutter/material.dart';
import '../../models/food.dart';
import 'food_detail_screen.dart';

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
        final food = filteredFoods[index];
        return ListTile(
          title: Text(food.name),
          leading: food.imageUrl.startsWith('http')
              ? Image.network(
                  food.imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                )
              : Image.asset(
                  food.imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => FoodDetailScreen(food),
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
