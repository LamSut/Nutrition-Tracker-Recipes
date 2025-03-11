import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'food_grid_tile.dart';
import 'foods_manager.dart';

class FoodsGrid extends StatelessWidget {
  const FoodsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final foods = context.watch<FoodsManager>().items;
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 2;
    if (screenWidth >= 1200) {
      crossAxisCount = 4;
    } else if (screenWidth >= 800) {
      crossAxisCount = 3;
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: foods.length,
      itemBuilder: (ctx, i) => FoodGridTile(foods[i]),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
