import 'package:flutter/material.dart';
import '../../models/food.dart';
import 'food_detail_screen.dart';

class FoodGridTile extends StatelessWidget {
  const FoodGridTile(
    this.food, {
    super.key,
  });
  final Food food;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: FoodGridFooter(
          food: food,
          onFavoritePressed: () {
            print('Toggle a favorite food');
          },
          onAddToCartPressed: () {
            print('Add item to cart');
          },
        ),
        child: GestureDetector(
          onTap: () {
            //Go to food detail screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => FoodDetailScreen(food),
              ),
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
    this.onFavoritePressed,
    this.onAddToCartPressed,
  });
  final Food food;
  final void Function()? onFavoritePressed;
  final void Function()? onAddToCartPressed;
  @override
  Widget build(BuildContext context) {
    return GridTileBar(
      backgroundColor: Colors.black87,
      leading: IconButton(
        icon: Icon(
          food.isFavorite ? Icons.favorite : Icons.favorite_border,
        ),
        color: Theme.of(context).colorScheme.secondary,
        onPressed: onFavoritePressed,
      ),
      title: Text(
        food.name,
        textAlign: TextAlign.center,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.playlist_add),
        onPressed: onAddToCartPressed,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
