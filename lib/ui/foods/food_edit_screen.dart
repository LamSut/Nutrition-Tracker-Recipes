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
      setState(() {
        _image = File(pickedFile.path);
      });
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
                _buildTextField('Name', _nameController),
                _buildTextField(
                    'Calories (kcal)', _caloriesController, 'Enter calories'),
                _buildTextField(
                    'Protein (g)', _proteinController, 'Enter protein'),
                _buildTextField('Fat (g)', _fatController, 'Enter fat'),
                _buildTextField('Carbohydrates (g)', _carbohydratesController,
                    'Enter carbohydrates'),
                _buildTextField('Fiber (g)', _fiberController, 'Enter fiber'),
                _buildDropdownField('Category', _selectedCategory,
                    ['Fruits', 'Vegetables', 'Proteins', 'Grains', 'Dairy']),
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
                        fontSize: 20,
                      ),
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

  Widget _buildTextField(String label, TextEditingController controller,
      [String? placeholder]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.grey[600])),
        const SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration.collapsed(hintText: placeholder ?? ''),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.grey[600])),
        const SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              onChanged: (val) => setState(() => _selectedCategory = val),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Image',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.grey[600])),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: _image != null
              ? Image.file(_image!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity)
              : widget.food != null
                  ? Image.asset(widget.food!.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity)
                  : Image.asset('assets/foods/default.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity),
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
            : (widget.food?.imageUrl ?? 'assets/foods/default.jpg'),
      );

      if (widget.food == null) {
        Provider.of<FoodsManager>(context, listen: false).addFood(newFood);
      } else {
        Provider.of<FoodsManager>(context, listen: false).updateFood(newFood);
      }
      Navigator.of(context).pop();
    }
  }
}
