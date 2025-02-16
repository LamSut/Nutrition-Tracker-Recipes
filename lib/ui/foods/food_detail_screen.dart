import 'package:flutter/material.dart';
import '../../models/food.dart';
import 'foods_overview_screen.dart';
import '../recipes/recipes_overview_screen.dart';

class FoodDetailScreen extends StatelessWidget {
  static const routeName = '/food_detail';
  const FoodDetailScreen(this.food, {super.key});

  final Food food;

  void _addToRecipe(BuildContext context) {
    RecipesScreen.addRecipe(food);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${food.name} added to your recipes!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, FoodsOverviewScreen.routeName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 4),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(food.imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Nutrients of ${food.name}',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    child: Table(
                      border: TableBorder.all(color: Colors.grey),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        _buildTableRow('Portion', '100g', isHeader: true),
                        _buildTableRow('Calories', '${food.calories} kcal'),
                        _buildTableRow('Protein', '${food.protein}g'),
                        _buildTableRow('Fat', '${food.fat}g'),
                        _buildTableRow(
                            'Carbohydrates', '${food.carbohydrates}g'),
                        _buildTableRow('Fiber', '${food.fiber}g'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.only(
                          top: 8, right: 12, bottom: 8, left: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => _addToRecipe(context),
                    child: const Text(
                      'Add to Recipe',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String name, String value, {bool isHeader = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
