import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/food.dart';
import '../user/users_manager.dart';
import 'food_edit_screen.dart';

class FoodDetailScreen extends StatelessWidget {
  static const routeName = '/food_detail';
  const FoodDetailScreen(this.food, {super.key});

  final Food food;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAdmin = Provider.of<UsersManager>(context, listen: false).isAdmin();

    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(20),
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
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNutrientTable(),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: isAdmin,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FoodEditScreen(food: food),
                          ),
                        );
                      },
                      child: const Text(
                        'Edit Food Information',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
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
          _buildTableRow('Carbohydrates', '${food.carbohydrates}g'),
          _buildTableRow('Fiber', '${food.fiber}g'),
        ],
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
