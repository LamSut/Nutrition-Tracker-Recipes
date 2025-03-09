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
            backgroundColor: Colors.black87,
            title: Row(
              children: [
                Image.asset('assets/logos/app-icon.png', height: 30, width: 30),
                const SizedBox(width: 10),
                const Text('Halo!'),
              ],
            ),
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
                  .pushReplacementNamed(RecipesOverviewScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('User'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProfileScreen.routeName);
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
