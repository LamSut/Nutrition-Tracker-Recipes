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
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
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
                    child: const Text(
                      'Choose New Image from Gallery',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    if (widget.food != null) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _confirmDelete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 180, 10, 0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                SizedBox(height: 60),
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
          labelStyle: const TextStyle(fontSize: 22),
          hintText: placeholder),
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
          labelText: 'Category', labelStyle: TextStyle(fontSize: 22)),
      items: ['Proteins', 'Grains', 'Vegetables', 'Fruits', 'Dairy']
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
        const Text('Product Image', style: TextStyle(fontSize: 22)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey),
          ),
          child: _image != null
              ? Image.asset(widget.food!.imageUrl, fit: BoxFit.cover)
              : widget.food != null
                  ? Image.asset(
                      widget.food!.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text('Image not found'));
                      },
                    )
                  : Image.asset('assets/foods/default.jpg', fit: BoxFit.cover),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final foodsManager = Provider.of<FoodsManager>(context, listen: false);
      foodsManager.updateFood(widget.food!.copyWith(
        name: _nameController.text,
        type: _selectedCategory,
      ));
      Navigator.of(context).pop();
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this food item?',
            style: TextStyle(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<FoodsManager>(context, listen: false)
                  .removeFood(widget.food!.id!);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.red, fontSize: 22)),
          ),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel', style: TextStyle(fontSize: 22))),
        ],
      ),
    );
  }
}
