// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../user/users_manager.dart';
// import '../../models/user.dart';

// class UserUpdateInformationScreen extends StatefulWidget {
//   static const routeName = '/user_update_information';
//   const UserUpdateInformationScreen({super.key});

//   @override
//   _UserUpdateInformationScreenState createState() => _UserUpdateInformationScreenState();
// }

// class _UserUpdateInformationScreenState extends State<UserUpdateInformationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _birthdayController = TextEditingController();
//   String? _selectedGender;
//   late User _user;

//   @override
//   void initState() {
//     super.initState();
//     _user = Provider.of<UserManager>(context, listen: false).loggedInUser!;
//     _nameController.text = _user.name;
//     _emailController.text = _user.email;
//     _birthdayController.text = DateFormat('dd/MM/yyyy').format(_user.birthday);
//     _selectedGender = _user.gender ? 'Male' : 'Female';
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _birthdayController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
//       });
//     }
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           title: const Center(child: Text(
//             'Confirm Update',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           )),
//           content: const Text('Are you sure you want to update your information?',
//                   style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w400,
//                 ),),
//           actionsAlignment: MainAxisAlignment.center,
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(ctx).pop(),
//               child: const Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 18)),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _user = _user.copyWith(
//                     name: _nameController.text,
//                     email: _emailController.text,
//                     birthday: DateFormat('dd/MM/yyyy').parse(_birthdayController.text),
//                     gender: _selectedGender == 'Male',
//                   );
//                 });
//                 Provider.of<UserManager>(context, listen: false).updateUser(_user);
//                 Navigator.of(ctx).pop();
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Update', style: TextStyle(color: Colors.teal, fontSize: 18)),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   CircleAvatar(
//                     radius: 80,
//                     backgroundImage: AssetImage(_user.profileImageUrl),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.white),
//                       onPressed: () {},
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Update Information',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     _buildTextField('Name', _nameController),
//                     _buildTextField('Email Address', _emailController, readOnly: false),
//                     _buildDateField('Date of Birth', _birthdayController),
//                     _buildDropdownField('Gender', _selectedGender, ['Male', 'Female']),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).colorScheme.primary,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 child: const Text('Save Changes',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller, {bool readOnly = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[600])),
//         const SizedBox(height: 5),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: TextFormField(
//             controller: controller,
//             style: TextStyle(fontSize: 16, color: Colors.black),
//             readOnly: readOnly,
//             decoration: InputDecoration.collapsed(hintText: ''),
//           ),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   Widget _buildDateField(String label, TextEditingController controller) {
//     return GestureDetector(
//       onTap: () => _selectDate(context),
//       child: AbsorbPointer(
//         child: _buildTextField(label, controller, readOnly: true),
//       ),
//     );
//   }

//   Widget _buildDropdownField(String label, String? value, List<String> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[600])),
//         const SizedBox(height: 5),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: value,
//               isExpanded: true,
//               onChanged: (val) => setState(() => _selectedGender = val),
//               items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }
// }
