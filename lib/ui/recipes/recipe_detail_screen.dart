import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/recipe.dart';
import '../recipes/recipes_manager.dart';

class RecipeDetailScreen extends StatelessWidget {
  static const routeName = '/recipe_detail';
  final Recipe recipe;

  const RecipeDetailScreen(this.recipe, {super.key});

  @override
  Widget build(BuildContext context) {
    final nutrition = Provider.of<RecipesManager>(context, listen: false)
        .calculateTotalNutrition(recipe);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(recipe.imageUrl, fit: BoxFit.cover),
              ),
            ),
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 10, right: 20, bottom: 10, left: 20),
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                },
                children: recipe.ingredients.map((ingredient) {
                  String quantityInGrams = '${ingredient.quantity * 100}g';
                  return _buildTableRow(ingredient.food.name, quantityInGrams);
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Nutrition Facts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 10, right: 20, bottom: 10, left: 20),
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                },
                children: [
                  _buildTableRow('Calories', '${nutrition['calories']} kcal'),
                  _buildTableRow('Protein', '${nutrition['protein']}g'),
                  _buildTableRow('Fat', '${nutrition['fat']}g'),
                  _buildTableRow(
                      'Carbohydrates', '${nutrition['carbohydrates']}g'),
                  _buildTableRow('Fiber', '${nutrition['fiber']}g'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String name, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
