import 'package:flutter/material.dart';
import 'food_grid_tile.dart';
import 'foods_manager.dart';

class FoodsGrid extends StatelessWidget {
  final bool showFavorites;
  const FoodsGrid(this.showFavorites, {super.key});
  @override
  Widget build(BuildContext context) {
    final foodsManager = FoodsManager();
    final foods =
        showFavorites ? foodsManager.favoriteItems : foodsManager.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: foods.length,
      itemBuilder: (ctx, i) => FoodGridTile(foods[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
