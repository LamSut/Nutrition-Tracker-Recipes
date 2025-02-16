import '../../models/user.dart';

class UsersManager {
  final List<User> _items = [
    User(
      id: 'u1',
      username: 'swimngu',
      password: 'moomoo',
      name: 'Chu Bo Ngoc Nghech',
      email: 'hohuyhao@example.com',
      profileImageUrl: 'assets/avatars/moomoo.png',
      birthday: DateTime(2003, 12, 24),
      gender: false,
    ),
    User(
      id: 'u2',
      username: 'anhmainsiungau',
      password: 'monkey',
      name: 'Chu Khi Dan',
      email: 'nguyenminhtien@example.com',
      profileImageUrl: 'assets/avatars/monkey.png',
      birthday: DateTime(2003, 2, 11),
      gender: true,
    ),
  ];

  int get itemCount {
    return _items.length;
  }

  List<User> get items {
    return [..._items];
  }

  User? findByUsername(String username) {
    try {
      return _items.firstWhere((user) => user.username == username);
    } catch (error) {
      return null;
    }
  }

  bool authenticate(String username, String password) {
    final user = findByUsername(username);
    return user != null && user.password == password;
  }
}
