import 'package:flutter/material.dart';
import '../recipes/recipes_overview_screen.dart';
import '../settings/settings_overview_screen.dart';

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
            title: const Text('Food Cards'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.list_alt_rounded),
            title: const Text('User Recipes'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(RecipesScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SettingsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
