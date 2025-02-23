import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../recipes/recipes_manager.dart';
import '../user/users_manager.dart';
import '../shared/app_drawer.dart';
import 'recipe_list_tile.dart';

class RecipesScreen extends StatelessWidget {
  static const routeName = '/recipes-overview';

  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipesManager = Provider.of<RecipesManager>(context);
    final usersManager = Provider.of<UsersManager>(context, listen: false);
    final loggedInUser = usersManager.loggedInUser;

    final userRecipes = recipesManager.items
        .where((recipe) => recipe.userID == loggedInUser?.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Recipes')),
      drawer: const AppDrawer(),
      body: userRecipes.isEmpty
          ? const Center(
              child: Text('No recipes found', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: userRecipes.length,
              itemBuilder: (ctx, index) {
                return RecipeListTile(recipe: userRecipes[index]);
              },
            ),
    );
  }
}
