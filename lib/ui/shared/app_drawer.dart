import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Halo!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.food_bank),
            title: const Text('Foods'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(FoodsOverviewScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.list_alt_rounded),
            title: const Text('Recipes'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(RecipesScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('User'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Provider.of<FoodsManager>(context, listen: false)
                  .setFoodType('All');
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
