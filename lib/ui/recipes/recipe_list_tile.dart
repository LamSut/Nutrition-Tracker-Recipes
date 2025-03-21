import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/recipe.dart';
import '../shared/dialog_utils.dart';
import 'recipes_manager.dart';
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
        return showConfirmDialog(
          context,
          'Would you remove this Recipe?',
        );
      },
      onDismissed: (direction) async {
        await recipesManager.deleteRecipe(recipe.id!);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: ListTile(
          contentPadding:
              const EdgeInsets.only(top: 6, right: 10, bottom: 6, left: 10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: recipe.imageUrl.isNotEmpty
                ? Image.network(
                    recipe.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/default/recipe.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      );
                    },
                  )
                : Image.asset(
                    'assets/default/recipe.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
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
            icon: Icon(Icons.edit,
                color: Theme.of(context).colorScheme.secondary),
            iconSize: 32,
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
