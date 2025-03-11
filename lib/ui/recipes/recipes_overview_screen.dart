import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../recipes/recipes_manager.dart';
import '../user/user_manager.dart';
import '../shared/app_drawer.dart';
import 'recipe_list_tile.dart';
import 'recipe_edit_screen.dart';

class RecipesOverviewScreen extends StatefulWidget {
  static const routeName = '/recipes-overview';

  const RecipesOverviewScreen({super.key});

  @override
  _RecipesOverviewScreenState createState() => _RecipesOverviewScreenState();
}

class _RecipesOverviewScreenState extends State<RecipesOverviewScreen> {
  late Future<void> _fetchRecipesFuture;

  @override
  void initState() {
    super.initState();
    _fetchRecipesFuture = _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    await Provider.of<RecipesManager>(context, listen: false).fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final recipesManager = Provider.of<RecipesManager>(context);
    final usersManager = Provider.of<UserManager>(context, listen: false);
    final loggedInUser = usersManager.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(RecipeEditScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchRecipesFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final userRecipes = recipesManager.items
                .where((recipe) => recipe.userId == loggedInUser?.id)
                .toList();
            return userRecipes.isEmpty
                ? const Center(
                    child: Text('No recipes found',
                        style: TextStyle(fontSize: 18)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: userRecipes.length,
                    itemBuilder: (ctx, index) {
                      return RecipeListTile(recipe: userRecipes[index]);
                    },
                  );
          }
        },
      ),
    );
  }
}
