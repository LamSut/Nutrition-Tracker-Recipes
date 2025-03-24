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
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: food.imageUrl.startsWith('http')
                ? Image.network(
                    food.imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/default/food.png',
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain),
                  )
                : (food.imageUrl == 'assets/default/food.png' ||
                        food.imageUrl.isEmpty)
                    ? Image.asset('assets/default/food.png',
                        width: 70, height: 70, fit: BoxFit.contain)
                    : Image.asset(
                        food.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/default/food.png',
                                width: 70, height: 70, fit: BoxFit.contain),
                      ),
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
