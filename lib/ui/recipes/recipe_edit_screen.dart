import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../models/recipe.dart';
import '../recipes/recipes_manager.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _nameController.text = widget.recipe!.name;
      _descriptionController.text = widget.recipe!.description;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final recipesManager =
          Provider.of<RecipesManager>(context, listen: false);
      final updatedRecipe = Recipe(
        id: widget.recipe?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        ingredients: widget.recipe?.ingredients ?? [],
        imageUrl: _image?.path ??
            widget.recipe?.imageUrl ??
            'assets/recipes/default.jpg',
        userID: widget.recipe?.userID ?? '',
      );

      if (widget.recipe == null) {
        recipesManager.addRecipe(updatedRecipe);
      } else {
        recipesManager.updateRecipe(widget.recipe!.id!, updatedRecipe);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? 'Add New Recipe' : 'Edit Recipe'),
      ),
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
                  if (widget.recipe != null) ...[
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
              const SizedBox(height: 60),
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
        labelStyle: const TextStyle(fontSize: 22),
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
        const Text('Recipe Image', style: TextStyle(fontSize: 22)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey),
          ),
          child: _image != null
              ? Image.file(_image!, fit: BoxFit.cover)
              : widget.recipe?.imageUrl.isNotEmpty == true
                  ? Image.asset(widget.recipe!.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('Image not found'));
                    })
                  : Image.asset('assets/recipes/default.jpg',
                      fit: BoxFit.cover),
        ),
      ],
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this recipe?',
            style: TextStyle(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<RecipesManager>(context, listen: false)
                  .removeRecipe(widget.recipe!.id!);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.red, fontSize: 22)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(fontSize: 22)),
          ),
        ],
      ),
    );
  }
}
