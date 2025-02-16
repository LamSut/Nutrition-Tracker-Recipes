import 'package:flutter/material.dart';
import '../../models/food.dart';
import 'food_detail_screen.dart';

class FoodGridTile extends StatefulWidget {
  const FoodGridTile(this.food, {super.key});

  final Food food;

  @override
  State<FoodGridTile> createState() => _FoodGridTileState();
}

class _FoodGridTileState extends State<FoodGridTile> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.food.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: FoodGridFooter(
          food: widget.food,
          isFavorite: _isFavorite,
          onFavoritePressed: _toggleFavorite,
          onAddToCartPressed: () {
            print('Add food to Recipe');
          },
        ),
        child: GestureDetector(
          onTap: () {
            // Navigate to food detail screen
            Navigator.of(context).pushNamed(
              FoodDetailScreen.routeName,
              arguments: widget.food.id,
            );
          },
          child: Image.asset(
            widget.food.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class FoodGridFooter extends StatelessWidget {
  const FoodGridFooter({
    super.key,
    required this.food,
    required this.isFavorite,
    this.onFavoritePressed,
    this.onAddToCartPressed,
  });

  final Food food;
  final bool isFavorite;
  final void Function()? onFavoritePressed;
  final void Function()? onAddToCartPressed;

  @override
  Widget build(BuildContext context) {
    return GridTileBar(
      backgroundColor: Colors.black87,
      leading: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
        ),
        color: Theme.of(context).colorScheme.secondary,
        onPressed: onFavoritePressed,
      ),
      title: Text(
        food.name,
        textAlign: TextAlign.center,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.playlist_add),
        onPressed: onAddToCartPressed,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
