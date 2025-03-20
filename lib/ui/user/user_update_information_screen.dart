import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../shared/dialog_utils.dart';
import '../user/user_manager.dart';

class UserUpdateInformationScreen extends StatefulWidget {
  static const routeName = '/user_update_information';
  const UserUpdateInformationScreen({super.key});

  @override
  _UserUpdateInformationScreenState createState() =>
      _UserUpdateInformationScreenState();
}

class _UserUpdateInformationScreenState
    extends State<UserUpdateInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  String? _selectedGender;
  late User _user;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    final userManager = Provider.of<UserManager>(context, listen: false);
    _user = userManager.user!;
    _nameController.text = _user.name;
    _birthdayController.text = formatDate(_user.birthday);
    _selectedGender = _user.gender ? 'Male' : 'Female';
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  DateTime? parseDate(String dateString) {
    try {
      final parts = dateString.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _user.birthday,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _birthdayController.text = formatDate(pickedDate);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      bool? confirm = await showConfirmDialog(
        context,
        'Do you really want to update your profile information?',
      );

      if (confirm == true) {
        try {
          final parsedBirthday = parseDate(_birthdayController.text);
          if (parsedBirthday == null) {
            showErrorDialog(context, 'Invalid birthday format.');
            return;
          }
          final updatedUser = _user.copyWith(
            name: _nameController.text,
            birthday: parsedBirthday,
            gender: _selectedGender == 'Male',
            profileImage: _profileImage,
          );

          Provider.of<UserManager>(context, listen: false)
              .updateUser(updatedUser);
          Navigator.of(context).pop();
        } catch (error) {
          showErrorDialog(
              context, 'Failed to update profile. Please try again.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : (_user.imageUrl != null && _user.imageUrl!.isNotEmpty
                          ? NetworkImage(_user.imageUrl!)
                          : null) as ImageProvider<Object>?,
                  child: (_profileImage == null &&
                          (_user.imageUrl == null || _user.imageUrl!.isEmpty))
                      ? const Icon(Icons.person, size: 100)
                      : null,
                ),
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    iconSize: 28,
                    onPressed: _pickImage,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Update Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField('Name', _nameController),
                  _buildDateField('Date of Birth', _birthdayController),
                  _buildDropdownField(
                      'Gender', _selectedGender, ['Male', 'Female']),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 40, right: 40),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                fontSize: 18)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(child: _buildTextField(label, controller)),
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                fontSize: 18)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              onChanged: (val) => setState(() => _selectedGender = val),
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
}
