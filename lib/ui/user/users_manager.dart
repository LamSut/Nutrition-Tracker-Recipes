import 'package:flutter/material.dart';
import '../../models/user.dart';

class UsersManager extends ChangeNotifier {
  final List<User> _items = [
    User(
      id: 'u0',
      username: 'admin',
      password: 'admin',
      name: 'Admin',
      email: 'admin@example.com',
      profileImageUrl: '',
      birthday: DateTime(2003, 1, 30),
      gender: true,
      role: true,
    ),
    User(
      id: 'u1',
      username: 'swimngu',
      password: 'moomoo',
      name: 'Chu Bo Ngoc Nghech',
      email: 'hohuyhao@example.com',
      profileImageUrl: 'assets/avatars/moomoo.png',
      birthday: DateTime(2003, 12, 24),
      gender: false,
      role: false,
    ),
    User(
      id: 'u2',
      username: 'anhmainsiungau',
      password: 'monkey',
      name: 'Chu Khi Dan',
      email: 'nguyenminhtien@example.com',
      profileImageUrl: 'assets/avatars/monkey.jpg',
      birthday: DateTime(2003, 2, 11),
      gender: true,
      role: false,
    ),
  ];

  User? _loggedInUser;

  int get itemCount => _items.length;

  List<User> get items => [..._items];

  User? get loggedInUser => _loggedInUser;

  User? findByUsername(String username) {
    try {
      return _items.firstWhere((user) => user.username == username);
    } catch (error) {
      return null;
    }
  }

  bool authenticate(String username, String password) {
    final user = findByUsername(username);
    if (user != null && user.password == password) {
      _loggedInUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> addUser(User newUser) async {
    _items.add(
      newUser.copyWith(
        id: 'u${DateTime.now().toIso8601String()}',
        profileImageUrl: 'assets/avatars/default.png',
      ).copyWith(password: newUser.password),
    );
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    final index = _items.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _items[index] = updatedUser;
      if (_loggedInUser?.id == updatedUser.id) {
        _loggedInUser = updatedUser;
      }
      notifyListeners();
    }
  }

  void updatePassword(String newPassword) {
    if (_loggedInUser != null) {
      _loggedInUser = _loggedInUser!.copyWith(password: newPassword);
      final index = _items.indexWhere((user) => user.id == _loggedInUser!.id);
      if (index != -1) {
        _items[index] = _loggedInUser!;
        notifyListeners();
      }
    }
  }

  bool isAdmin() {
    return _loggedInUser?.role ?? false;
  }
}
