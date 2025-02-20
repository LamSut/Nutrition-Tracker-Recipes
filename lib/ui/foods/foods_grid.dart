import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'food_grid_tile.dart';
import 'foods_manager.dart';

class FoodsGrid extends StatelessWidget {
  const FoodsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final foods = context.watch<FoodsManager>().items;

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
