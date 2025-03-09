// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../user/users_manager.dart';

// class UserUpdatePasswordScreen extends StatefulWidget {
//   static const routeName = '/user_update_password';
//   const UserUpdatePasswordScreen({super.key});

//   @override
//   _UserUpdatePasswordScreenState createState() => _UserUpdatePasswordScreenState();
// }

// class _UserUpdatePasswordScreenState extends State<UserUpdatePasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _newPasswordController = TextEditingController();
//   final _retypePasswordController = TextEditingController();

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       if (_newPasswordController.text == _retypePasswordController.text) {
//         final usersManager = Provider.of<UserManager>(context, listen: false);
//         usersManager.updatePassword(_newPasswordController.text);
//         Navigator.of(context).pop();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Passwords do not match')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Change Password'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildTextField('New Password', _newPasswordController),
//                 const SizedBox(height: 10),
//                 _buildTextField('Retype New Password', _retypePasswordController),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _submitForm,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Theme.of(context).colorScheme.primary,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     child: const Text(
//                       'Save Changes',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(bottom: 5),
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.black54,
//             ),
//           ),
//         ),
//         TextFormField(
//           controller: controller,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.grey[200],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//           ),
//           obscureText: true,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter your password';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
// }
