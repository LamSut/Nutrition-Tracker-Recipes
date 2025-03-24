import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/app_drawer.dart';
import 'user_manager.dart';
import 'user_update_information_screen.dart';
import 'user_update_password_screen.dart';

class UserProfileScreen extends StatelessWidget {
  static const routeName = '/user_profile';
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserManager>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      drawer: const AppDrawer(),
      body: user == null
          ? const Center(child: Text('No user logged in'))
          : LayoutBuilder(
              builder: (context, constraints) {
                final bool isWide = constraints.maxWidth > 600;
                final double contentWidth =
                    isWide ? constraints.maxWidth * 0.6 : constraints.maxWidth;

                return SingleChildScrollView(
                  child: Align(
                    alignment: isWide ? Alignment.center : Alignment.topCenter,
                    child: Container(
                      width: contentWidth,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          CircleAvatar(
                            radius: 100,
                            backgroundImage: _buildProfileImage(user.imageUrl),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'User Information',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildInfoField('Username', user.username),
                          _buildInfoField('Full Name', user.name),
                          _buildInfoField(
                              'Gender', user.gender ? 'Male' : 'Female'),
                          _buildInfoField(
                            'Date of Birth',
                            '${user.birthday.toLocal().day}/${user.birthday.toLocal().month}/${user.birthday.toLocal().year}',
                          ),
                          _buildInfoField('Email Address', user.email),
                          _buildSettingsSection(context),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  ImageProvider _buildProfileImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.trim().isNotEmpty) {
      return NetworkImage(imageUrl);
    }
    return const AssetImage('assets/default/avatar.png');
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Settings',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        _buildSettingsButton(
          icon: Icons.edit,
          title: 'Change Information',
          onPressed: () {
            Navigator.pushNamed(context, UserUpdateInformationScreen.routeName);
          },
        ),
        _buildSettingsButton(
          icon: Icons.lock,
          title: 'Change Password',
          onPressed: () {
            Navigator.pushNamed(context, UserUpdatePasswordScreen.routeName);
          },
        ),
      ],
    );
  }

  Widget _buildSettingsButton({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
        onTap: onPressed,
      ),
    );
  }
}
