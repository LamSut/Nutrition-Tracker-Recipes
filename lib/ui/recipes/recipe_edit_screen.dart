import 'package:NTR/ui/user/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../models/recipe.dart';
import '../../models/food.dart';
import '../recipes/recipes_manager.dart';
import '../foods/foods_manager.dart';
import '../foods/food_detail_screen.dart';
import '../shared/dialog_utils.dart';
import 'recipe_nutrient_table.dart';

class RecipeEditScreen extends StatefulWidget {
  static const routeName = '/recipe_edit';
  final Recipe? recipe;

  const RecipeEditScreen({super.key, this.recipe});

  @override
  _RecipeEditScreenState createState() => _RecipeEditScreenState();
}

class _RecipeEditScreenState extends State<RecipeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _image;
  String _currentFoodType = 'All';
  Food? _currentFood;
  double _quantity = 0;
  final List<RecipeIngredient> _ingredients = [];

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _nameController.text = widget.recipe!.name;
      _descriptionController.text = widget.recipe!.description;
      _ingredients.addAll(widget.recipe!.ingredients);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  void _navigateToFoodDetail(Food food) {
    Navigator.of(context)
        .pushNamed(FoodDetailScreen.routeName, arguments: food.id);
  }

  void _addIngredient() {
    if (_currentFood != null && _quantity > 0) {
      setState(() {
        int existingIndex = _ingredients
            .indexWhere((ingredient) => ingredient.food.id == _currentFood!.id);
        if (existingIndex != -1) {
          _ingredients[existingIndex] = RecipeIngredient(
            food: _ingredients[existingIndex].food,
            quantity: _ingredients[existingIndex].quantity + _quantity,
          );
        } else {
          _ingredients
              .add(RecipeIngredient(food: _currentFood!, quantity: _quantity));
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final confirm = await showConfirmDialog(
        context,
        widget.recipe == null
            ? 'Do you want to add this recipe?'
            : 'Do you want to update this recipe?',
      );
      if (confirm != true) return;

      final recipesManager =
          Provider.of<RecipesManager>(context, listen: false);
      final userId = Provider.of<UserManager>(context, listen: false).user?.id;

      final updatedRecipe = Recipe(
        id: widget.recipe?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        ingredients: _ingredients,
        featuredImage: _image,
        imageUrl: widget.recipe?.imageUrl ?? '',
        userId: widget.recipe?.userId ?? userId!,
      );

      if (widget.recipe == null) {
        recipesManager.addRecipe(updatedRecipe);
      } else {
        recipesManager.updateRecipe(updatedRecipe);
      }
      Navigator.of(context).pop();
    }
  }

  void _confirmDelete() async {
    final confirm = await showConfirmDialog(
      context,
      'Are you sure you want to delete this recipe?',
    );
    if (confirm == true) {
      Provider.of<RecipesManager>(context, listen: false)
          .deleteRecipe(widget.recipe!.id!);
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/recipes-overview',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final foodsManager = Provider.of<FoodsManager>(context);
    final recipesManager = Provider.of<RecipesManager>(context);
    final availableFoods = foodsManager.items;
    final nutrition = recipesManager.calculateTotalNutrition(
      Recipe(
        id: '',
        name: '',
        description: '',
        ingredients: _ingredients,
        imageUrl: '',
        userId: '',
      ),
    );
    return Scaffold(
      appBar: AppBar(
          title:
              Text(widget.recipe == null ? 'Add New Recipe' : 'Edit Recipe')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Recipe Name', _nameController, 'Enter name'),
              _buildTextField(
                  'Description', _descriptionController, 'Enter description',
                  isMultiline: true),
              const SizedBox(height: 20),
              _buildImagePicker(),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Choose New Image from Gallery',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
              _buildFoodSelector(availableFoods),
              const SizedBox(height: 40),
              _buildCurrentIngredientsTable(),
              const SizedBox(height: 20),
              RecipeNutrientTable(
                controllers: {
                  'calories': TextEditingController(
                      text: '${nutrition['calories']} kcal'),
                  'protein':
                      TextEditingController(text: '${nutrition['protein']}g'),
                  'fat': TextEditingController(text: '${nutrition['fat']}g'),
                  'carbohydrates': TextEditingController(
                      text: '${nutrition['carbohydrates']}g'),
                  'fiber':
                      TextEditingController(text: '${nutrition['fiber']}g'),
                },
                isEditable: false,
              ),
              const SizedBox(height: 20),
              _buildActionButtons(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String placeholder,
      {bool isMultiline = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isMultiline ? TextInputType.multiline : TextInputType.text,
      maxLines: isMultiline ? 3 : 1,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        hintText: placeholder,
      ),
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recipe Image',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey),
          ),
          child: _image != null
              ? Image.file(_image!, fit: BoxFit.contain)
              : widget.recipe != null && widget.recipe!.imageUrl.isNotEmpty
                  ? Image.network(
                      widget.recipe!.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text('Image not found'));
                      },
                    )
                  : Image.asset('assets/default/recipe.png',
                      fit: BoxFit.contain),
        ),
      ],
    );
  }

  Widget _buildFoodSelector(List<Food> availableFoods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selected Ingredients',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: _currentFoodType,
          onChanged: (value) {
            setState(() {
              _currentFoodType = value!;
              _currentFood = null;
            });
          },
          items: ['All', 'Fruits', 'Vegetables', 'Proteins', 'Dairy']
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
        ),
        Row(
          children: [
            Expanded(
              child: DropdownButton<Food>(
                value: availableFoods.any((food) =>
                        _currentFoodType == 'All' ||
                        food.type == _currentFoodType)
                    ? _currentFood
                    : null,
                onChanged: (value) => setState(() => _currentFood = value),
                items: availableFoods
                    .where((food) =>
                        _currentFoodType == 'All' ||
                        food.type == _currentFoodType)
                    .map((food) => DropdownMenuItem(
                          value: food,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(food.name),
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () => _navigateToFoodDetail(food),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 120,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Quantity (x100g)'),
                style: const TextStyle(fontSize: 18),
                onChanged: (value) => _quantity = double.tryParse(value) ?? 1.0,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.teal),
              onPressed: _addIngredient,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentIngredientsTable() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: const Text(
            'Current Ingredients',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        if (_ingredients.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'No Ingredients',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          )
        else
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(0.8),
                2: FlexColumnWidth(0.6),
              },
              children: _ingredients.map((ingredient) {
                return TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                ingredient.food.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.visibility, size: 24),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () =>
                                  _navigateToFoodDetail(ingredient.food),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '${ingredient.quantity * 100}g',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red, size: 22),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () =>
                              setState(() => _ingredients.remove(ingredient)),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (widget.recipe == null) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text(
              'Add New Recipe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text(
                'Update Recipe',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: _confirmDelete,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 180, 10, 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: const Text(
                'Delete Recipe',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
