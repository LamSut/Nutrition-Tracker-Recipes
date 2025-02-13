import 'package:flutter/material.dart';
import '../../models/food.dart';

class FoodDetailScreen extends StatelessWidget {
  static const routeName = '/food_detail';
  const FoodDetailScreen(this.food, {super.key});

  final Food food;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 300,
              width: double.infinity,
              child:
                  Image.asset(food.imageUrl, fit: BoxFit.cover), // Using assets
            ),
            const SizedBox(height: 18),
            Text(
              '${food.calories} kcal',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Protein: ${food.protein}g',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Fat: ${food.fat}g',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Carbohydrates: ${food.carbohydrates}g',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Fiber: ${food.fiber}g',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
