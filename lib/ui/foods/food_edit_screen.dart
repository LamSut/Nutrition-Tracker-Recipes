import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'foods_manager.dart';
import '../../models/food.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class FoodEditScreen extends StatefulWidget {
  static const routeName = '/food_edit';
  final Food? food;

  const FoodEditScreen({super.key, this.food});

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
      if (widget.food!.imageUrl.startsWith('assets/foods/')) {
        _image = File(widget.food!.imageUrl);
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food == null ? 'Add New Food' : 'Edit Food'),
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
                const SizedBox(height: 10),
                _buildImagePicker(),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Choose New Image from Gallery'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
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
      decoration: InputDecoration(labelText: label, hintText: placeholder),
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
      decoration: const InputDecoration(labelText: 'Category'),
      items: ['Fruits', 'Vegetables', 'Proteins', 'Grains', 'Dairy']
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (val) => setState(() => _selectedCategory = val),
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Product Image',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: _image != null
              ? Image.file(_image!, fit: BoxFit.cover)
              : widget.food != null
                  ? Image.asset(widget.food!.imageUrl, fit: BoxFit.cover)
                  : Image.asset('assets/foods/default.jpg', fit: BoxFit.cover),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newFood = Food(
        id: widget.food?.id ?? 'f${DateTime.now().toIso8601String()}',
        name: _nameController.text,
        type: _selectedCategory!,
        calories: double.parse(_caloriesController.text),
        protein: double.parse(_proteinController.text),
        fat: double.parse(_fatController.text),
        carbohydrates: double.parse(_carbohydratesController.text),
        fiber: double.parse(_fiberController.text),
        imageUrl: _image != null
            ? 'assets/foods/${p.basename(_image!.path)}'
            : widget.food?.imageUrl ?? 'assets/foods/default.jpg',
      );
      final foodsManager = Provider.of<FoodsManager>(context, listen: false);
      if (widget.food == null) {
        foodsManager.addFood(newFood);
      } else {
        foodsManager.updateFood(newFood);
      }
      Navigator.of(context).pop();
    }
  }
}
