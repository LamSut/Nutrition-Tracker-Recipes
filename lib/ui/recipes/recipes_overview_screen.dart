import 'package:flutter/material.dart';
import '../../models/food.dart';
import '../shared/app_drawer.dart';

class RecipesScreen extends StatefulWidget {
  static const routeName = '/recipes';
  static final List<Food> _recipes = [];

  static void addRecipe(Food food) {
    _recipes.add(food);
  }

  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  void _removeRecipe(int index) {
    setState(() {
      RecipesScreen._recipes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Recipes'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: RecipesScreen._recipes.length,
        itemBuilder: (ctx, index) {
          final food = RecipesScreen._recipes[index];
          return Dismissible(
            key: ValueKey(food.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _removeRecipe(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${food.name} removed from your recipes!')),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              leading: Image.asset(food.imageUrl, width: 50, height: 50),
              title: Text(food.name),
              subtitle: Text('${food.calories} kcal'),
            ),
          );
        },
      ),
    );
  }
}
