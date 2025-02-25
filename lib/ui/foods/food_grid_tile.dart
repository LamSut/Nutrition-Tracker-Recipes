import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/food.dart';
import 'food_detail_screen.dart';
import 'food_edit_screen.dart';
import '../user/users_manager.dart';

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
            final isAdmin = Provider.of<UsersManager>(context, listen: false).isAdmin();
            if (isAdmin) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => FoodEditScreen(food: food),
                ),
              );
            } else {
              print('Add food to Recipe');
            }
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
    final isAdmin = Provider.of<UsersManager>(context, listen: false).isAdmin();

    return GridTileBar(
      backgroundColor: Colors.black87,
      title: Text(
        food.name,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: IconButton(
        icon: Icon(isAdmin ? Icons.edit : Icons.playlist_add),
        onPressed: onAddToRecipePressed,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
