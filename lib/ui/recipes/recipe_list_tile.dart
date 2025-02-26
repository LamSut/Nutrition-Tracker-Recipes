import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/recipe.dart';
import '../recipes/recipes_manager.dart';
import 'recipe_detail_screen.dart';
import 'recipe_edit_screen.dart';

class RecipeListTile extends StatelessWidget {
  final Recipe recipe;

  const RecipeListTile({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final recipesManager = Provider.of<RecipesManager>(context, listen: false);

    return Dismissible(
      key: ValueKey(recipe.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to remove this recipe?',
                style: TextStyle(fontSize: 20)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Yes',
                    style: TextStyle(color: Colors.teal, fontSize: 18)),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('No',
                    style: TextStyle(color: Colors.red, fontSize: 18)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        recipesManager.removeRecipe(recipe.id!);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12.0),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              recipe.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            recipe.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            recipe.description,
            style: const TextStyle(fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              RecipeDetailScreen.routeName,
              arguments: recipe.id,
            );
          },
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.secondary,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                RecipeEditScreen.routeName,
                arguments: recipe.id,
              );
            },
          ),
        ),
      ),
    );
  }
}
