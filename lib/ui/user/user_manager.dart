import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';

class UserManager extends ChangeNotifier {
  late final UserService _userService;
  User? _loggedInUser;

  UserManager() {
    _userService = UserService(onAuthChange: (User? user) {
      _loggedInUser = user;
      notifyListeners();
    });
  }

  User? get user => _loggedInUser;

  bool get isAuth => _loggedInUser != null;

  bool get isAdmin => _loggedInUser?.role ?? false;

  Future<User> signup({
    required String username,
    required String email,
    required String name,
    required DateTime birthday,
    required bool gender,
    required String password,
  }) async {
    await _userService.signup(
      username: username,
      email: email,
      name: name,
      birthday: birthday,
      gender: gender,
      password: password,
    );

    // auto login after signup for setup session
    final user = await login(username, password);
    return user;
  }

  Future<User> login(String username, String password) async {
    final user = await _userService.login(username, password);
    _loggedInUser = user;
    notifyListeners();
    return user;
  }

  Future<void> tryAutoLogin() async {
    final user = await _userService.getUserFromStore();
    if (user != null) {
      _loggedInUser = user;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _userService.logout();
    _loggedInUser = null;
    notifyListeners();
  }

  Future<User?> updateUser(User updatedUser) async {
    final user = await _userService.updateUser(updatedUser);
    if (user != null) {
      _loggedInUser = user;
      notifyListeners();
    }
    return user;
  }

  Future<User?> updatePassword(String oldPassword, String newPassword) async {
    final user = await _userService.updatePassword(oldPassword, newPassword);
    if (user != null) {
      _loggedInUser = user;
      notifyListeners();
    }
    return user;
  }
}
