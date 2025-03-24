import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/recipe.dart';
import '../recipes/recipes_manager.dart';
import 'recipe_edit_screen.dart';
import 'recipe_nutrient_table.dart';

class RecipeDetailScreen extends StatelessWidget {
  static const routeName = '/recipe_detail';
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nutrition = Provider.of<RecipesManager>(context, listen: false)
        .calculateTotalNutrition(recipe);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 600;
          final double contentWidth =
              isWide ? constraints.maxWidth * 0.6 : constraints.maxWidth;

          return SingleChildScrollView(
            child: Align(
              alignment: isWide ? Alignment.center : Alignment.topCenter,
              child: Container(
                width: contentWidth,
                padding: const EdgeInsets.all(16.0),
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
                        child: recipe.imageUrl.isNotEmpty
                            ? Image.network(
                                recipe.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  'assets/default/recipe.png',
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Image.asset(
                                'assets/default/recipe.png',
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        recipe.description,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Ingredients',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Table(
                        border: TableBorder.all(color: Colors.grey),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                        },
                        children: recipe.ingredients.map((ingredient) {
                          String quantityInGrams =
                              '${ingredient.quantity * 100}g';
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  ingredient.food.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  quantityInGrams,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Nutrition Facts',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    RecipeNutrientTable(
                      controllers: {
                        'calories': TextEditingController(
                            text: '${nutrition['calories']}kcal'),
                        'protein': TextEditingController(
                            text: '${nutrition['protein']}g'),
                        'fat':
                            TextEditingController(text: '${nutrition['fat']}g'),
                        'carbohydrates': TextEditingController(
                            text: '${nutrition['carbohydrates']}g'),
                        'fiber': TextEditingController(
                            text: '${nutrition['fiber']}g'),
                      },
                      isEditable: false,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeEditScreen(recipe: recipe),
                          ),
                        );
                      },
                      child: const Text(
                        'Update Your Recipe',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
