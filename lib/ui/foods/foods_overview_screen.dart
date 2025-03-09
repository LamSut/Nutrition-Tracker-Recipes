import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/app_drawer.dart';
import 'foods_grid.dart';
import 'food_search_delegate.dart';
import 'foods_manager.dart';
import '../user/user_manager.dart';
import 'food_edit_screen.dart';
import '../user/user_auth_screen.dart';

class FoodsOverviewScreen extends StatelessWidget {
  static const routeName = '/food_overview';

  const FoodsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foodsManager = Provider.of<FoodsManager>(context);
    final allFoods = foodsManager.allFoods; // remove filters before search
    final userManager = Provider.of<UserManager>(context);
    final isAdmin = userManager.isAdmin;

    return PopScope(
      canPop: !isAdmin, // prevent back navigation
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Food Items'),
          automaticallyImplyLeading: !isAdmin, // remove back button
          leading: isAdmin
              ? IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    Provider.of<FoodsManager>(context, listen: false)
                        .setFoodType('All');
                    Navigator.of(context)
                        .pushReplacementNamed(UserAuthScreen.routeName);
                  },
                )
              : null,
          actions: <Widget>[
            if (isAdmin)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(FoodEditScreen.routeName);
                },
              ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: FoodSearchDelegate(allFoods),
                );
              },
            ),
          ],
        ),
        drawer: isAdmin ? null : const AppDrawer(),
        body: Column(
          children: [
            const FoodTypeFilterMenu(),
            const Expanded(child: FoodsGrid()),
          ],
        ),
      ),
    );
  }
}

class FoodTypeFilterMenu extends StatelessWidget {
  const FoodTypeFilterMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final foodsManager = Provider.of<FoodsManager>(context);
    final currentType = foodsManager.selectedType;
    final categories = [
      {'name': 'All', 'image': 'assets/food-types/all.jpg'},
      {'name': 'Proteins', 'image': 'assets/food-types/proteins.jpg'},
      {'name': 'Grains', 'image': 'assets/food-types/grains.jpg'},
      {'name': 'Vegetables', 'image': 'assets/food-types/vegetables.jpg'},
      {'name': 'Fruits', 'image': 'assets/food-types/fruits.jpg'},
      {'name': 'Dairy', 'image': 'assets/food-types/dairy.jpg'},
    ];

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (ctx, index) {
          final category = categories[index];
          final isSelected = currentType == category['name'];
          return GestureDetector(
            onTap: () => foodsManager.setFoodType(category['name']!),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              padding:
                  const EdgeInsets.only(top: 8, right: 14, bottom: 0, left: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      category['image']!,
                      width: 120,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category['name']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
