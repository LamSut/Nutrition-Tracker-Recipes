import 'package:flutter/material.dart';
import '../../models/food.dart';
import 'food_detail_screen.dart';

class FoodGridTile extends StatelessWidget {
  const FoodGridTile(this.food, {super.key});

  final Food food;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: FoodGridFooter(
          food: food,
          onAddToRecipePressed: () {
            print('Add food to Recipe');
          },
        ),
        child: GestureDetector(
          onTap: () {
            // Navigate to food detail screen
            Navigator.of(context).pushNamed(
              FoodDetailScreen.routeName,
              arguments: food.id,
            );
          },
          child: Image.asset(
            food.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class FoodGridFooter extends StatelessWidget {
  const FoodGridFooter({
    super.key,
    required this.food,
    this.onAddToRecipePressed,
  });

  final Food food;
  final void Function()? onAddToRecipePressed;

  @override
  Widget build(BuildContext context) {
    return GridTileBar(
      backgroundColor: Colors.black87,
      title: Text(
        food.name,
        textAlign: TextAlign.left,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.playlist_add),
        onPressed: onAddToRecipePressed,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
