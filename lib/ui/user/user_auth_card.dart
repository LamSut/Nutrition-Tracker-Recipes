import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/dialog_utils.dart';
import 'user_manager.dart';

enum AuthMode { signup, login }

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final _isSubmitting = ValueNotifier<bool>(false);

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _selectedBirthday;
  bool _isMale = true; // default is male

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (_authMode == AuthMode.signup && _selectedBirthday == null) {
      showErrorDialog(context, 'Please choose your birthday!');
      return;
    }

    _isSubmitting.value = true;

    try {
      if (_authMode == AuthMode.login) {
        await context.read<UserManager>().login(
              _usernameController.text.trim(),
              _passwordController.text,
            );
      } else {
        await context.read<UserManager>().signup(
              username: _usernameController.text.trim(),
              email: _emailController.text.trim(),
              name: _nameController.text.trim(),
              birthday: _selectedBirthday!,
              gender: _isMale,
              password: _passwordController.text,
            );
        _switchAuthMode();
      }
    } catch (error) {
      log('$error');
      if (mounted) {
        showErrorDialog(context, error.toString());
      }
    }

    _isSubmitting.value = false;
  }

  void _switchAuthMode() {
    setState(() {
      _authMode =
          _authMode == AuthMode.login ? AuthMode.signup : AuthMode.login;

      // Xóa dữ liệu khi chuyển chế độ
      _usernameController.clear();
      _emailController.clear();
      _nameController.clear();
      _birthdayController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _selectedBirthday = null;
      _isMale = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.sizeOf(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.signup ? 540 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signup ? 540 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildUsernameField(),
                if (_authMode == AuthMode.signup) _buildEmailField(),
                if (_authMode == AuthMode.signup) _buildNameField(),
                if (_authMode == AuthMode.signup) _buildBirthdayField(),
                if (_authMode == AuthMode.signup) _buildGenderField(),
                _buildPasswordField(),
                if (_authMode == AuthMode.signup) _buildPasswordConfirmField(),
                const SizedBox(height: 20),
                ValueListenableBuilder<bool>(
                  valueListenable: _isSubmitting,
                  builder: (context, isSubmitting, child) {
                    return isSubmitting
                        ? const CircularProgressIndicator()
                        : _buildSubmitButton();
                  },
                ),
                _buildAuthModeSwitchButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(labelText: 'Username'),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your username!';
        }
        if (_authMode == AuthMode.signup && value.length < 5) {
          return 'Username must be at least 5 characters!';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: 'E-Mail'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'Invalid email!';
        }
        return null;
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'Full Name'),
      keyboardType: TextInputType.text,
      validator: (value) => value == null || value.trim().isEmpty
          ? 'Please enter your name!'
          : null,
    );
  }

  Widget _buildBirthdayField() {
    return TextFormField(
      controller: _birthdayController,
      decoration: InputDecoration(
        labelText: 'Birthday',
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: _pickDate,
        ),
      ),
      validator: (value) => value == null || value.isEmpty
          ? 'Please select your birthday!'
          : null,
    );
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedBirthday = pickedDate;
        _birthdayController.text = pickedDate.toIso8601String().split('T')[0];
      });
    }
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Gender'),
      value: _isMale ? 'Male' : 'Female',
      items: const [
        DropdownMenuItem(value: 'Male', child: Text('Male')),
        DropdownMenuItem(value: 'Female', child: Text('Female')),
      ],
      onChanged: (value) => setState(() => _isMale = value == 'Male'),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password!';
        }
        if (_authMode == AuthMode.signup && value.length < 8) {
          return 'Password must be at least 8 characters!';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordConfirmField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: const InputDecoration(labelText: 'Confirm Password'),
      obscureText: true,
      validator: (value) =>
          value != _passwordController.text ? 'Passwords do not match!' : null,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
    );
  }

  Widget _buildAuthModeSwitchButton() {
    return TextButton(
      onPressed: _switchAuthMode,
      child: Text(
        _authMode == AuthMode.login
            ? 'Don\'t have an account? Sign up!'
            : 'Already have an account? Log in!',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
