import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/food.dart';
import '../shared/dialog_utils.dart';
import 'foods_manager.dart';
import 'dart:io';

class FoodEditScreen extends StatefulWidget {
  static const routeName = '/food_edit';
  final Food? food;

  const FoodEditScreen({Key? key, this.food}) : super(key: key);

  @override
  _FoodEditScreenState createState() => _FoodEditScreenState();
}

class _FoodEditScreenState extends State<FoodEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbohydratesController = TextEditingController();
  final _fiberController = TextEditingController();
  String? _selectedCategory;
  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.food != null) {
      _nameController.text = widget.food!.name;
      _caloriesController.text = widget.food!.calories.toString();
      _proteinController.text = widget.food!.protein.toString();
      _fatController.text = widget.food!.fat.toString();
      _carbohydratesController.text = widget.food!.carbohydrates.toString();
      _fiberController.text = widget.food!.fiber.toString();
      _selectedCategory = widget.food!.type;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final confirmed = await showConfirmDialog(
        context,
        'Do you want to submit this Food?',
      );
      if (confirmed != true) return;

      final foodsManager = Provider.of<FoodsManager>(context, listen: false);

      if (widget.food == null) {
        final newFood = Food(
          id: DateTime.now().toString(),
          name: _nameController.text,
          calories: double.tryParse(_caloriesController.text) ?? 0,
          protein: double.tryParse(_proteinController.text) ?? 0,
          fat: double.tryParse(_fatController.text) ?? 0,
          carbohydrates: double.tryParse(_carbohydratesController.text) ?? 0,
          fiber: double.tryParse(_fiberController.text) ?? 0,
          type: _selectedCategory!,
          featuredImage: _image,
          imageUrl: _image?.path ?? 'assets/default/food.png',
        );
        await foodsManager.addFood(newFood);
      } else {
        final updatedFood = widget.food!.copyWith(
          name: _nameController.text,
          calories: double.tryParse(_caloriesController.text) ?? 0,
          protein: double.tryParse(_proteinController.text) ?? 0,
          fat: double.tryParse(_fatController.text) ?? 0,
          carbohydrates: double.tryParse(_carbohydratesController.text) ?? 0,
          fiber: double.tryParse(_fiberController.text) ?? 0,
          type: _selectedCategory!,
          featuredImage: _image,
          imageUrl: _image?.path ?? widget.food!.imageUrl,
        );
        await foodsManager.updateFood(updatedFood);
      }
      Navigator.of(context).pop();
    }
  }

  void _confirmDelete() async {
    final confirmation = await showConfirmDialog(
      context,
      'Do you want to delete this Food?',
    );
    if (confirmation == true) {
      final foodsManager = Provider.of<FoodsManager>(context, listen: false);
      await foodsManager.deleteFood(widget.food!.id!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.food != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Food' : 'Add New Food'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Name', _nameController, 'Enter name'),
                _buildTextField(
                    'Calories (kcal)', _caloriesController, 'Enter calories',
                    isNumeric: true),
                _buildTextField(
                    'Protein (g)', _proteinController, 'Enter protein',
                    isNumeric: true),
                _buildTextField('Fat (g)', _fatController, 'Enter fat',
                    isNumeric: true),
                _buildTextField('Carbohydrates (g)', _carbohydratesController,
                    'Enter carbohydrates',
                    isNumeric: true),
                _buildTextField('Fiber (g)', _fiberController, 'Enter fiber',
                    isNumeric: true),
                _buildDropdownField(),
                const SizedBox(height: 20),
                _buildImagePicker(),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Choose New Image',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isEditing)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary),
                          child: const Text(
                            'Add New Food',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    if (isEditing) ...[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary),
                          child: const Text(
                            'Update Food',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _confirmDelete,
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 180, 10, 0)),
                          child: const Text(
                            'Delete Food',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String placeholder,
      {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 18),
        hintText: placeholder,
        hintStyle: const TextStyle(fontSize: 18),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        if (isNumeric && double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        labelStyle: TextStyle(fontSize: 18),
      ),
      items: ['Proteins', 'Grains', 'Vegetables', 'Fruits', 'Dairy']
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(fontSize: 18)),
              ))
          .toList(),
      onChanged: (val) => setState(() => _selectedCategory = val),
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Food Image',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 300,
          color: Colors.grey[200],
          child: _image != null
              ? Image.file(_image!, fit: BoxFit.contain)
              : (widget.food != null && widget.food!.imageUrl.isNotEmpty)
                  ? (widget.food!.imageUrl.startsWith('http')
                      ? Image.network(widget.food!.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Center(child: Text('Image not found')))
                      : Image.asset(widget.food!.imageUrl, fit: BoxFit.contain))
                  : Image.asset('assets/default/food.png', fit: BoxFit.contain),
        ),
      ],
    );
  }
}
