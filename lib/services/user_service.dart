import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../models/user.dart';
import 'pocketbase_client.dart';

class UserService {
  void Function(User? user)? onAuthChange;

  UserService({this.onAuthChange}) {
    if (onAuthChange != null) {
      getPocketbaseInstance().then((pb) {
        pb.authStore.onChange.listen((event) {
          onAuthChange!(
            event.record == null
                ? null
                : User.fromJson(
                    event.record!.toJson()
                      ..addAll(
                          {'imageUrl': _getProfileImageUrl(pb, event.record!)}),
                  ),
          );
        });
      });
    }
  }

  String _getProfileImageUrl(PocketBase pb, RecordModel userModel) {
    final imageName = userModel.getStringValue('profileImage');
    return imageName.isNotEmpty
        ? pb.files.getUrl(userModel, imageName).toString()
        : '';
  }

  Future<List<User>> fetchUsers() async {
    final List<User> users = [];
    try {
      final pb = await getPocketbaseInstance();
      final userModels = await pb.collection('users').getFullList();
      for (final userModel in userModels) {
        users.add(
          User.fromJson(
            userModel.toJson()
              ..addAll({'imageUrl': _getProfileImageUrl(pb, userModel)}),
          ),
        );
      }
      return users;
    } catch (error) {
      return users;
    }
  }

  Future<User?> getUser(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      final userModel = await pb.collection('users').getOne(id);
      return User.fromJson(
        userModel.toJson()
          ..addAll({'imageUrl': _getProfileImageUrl(pb, userModel)}),
      );
    } catch (error) {
      return null;
    }
  }

  Future<User> signup({
    required String username,
    required String email,
    required String name,
    required DateTime birthday,
    required bool gender,
    required String password,
  }) async {
    final pb = await getPocketbaseInstance();
    try {
      final record = await pb.collection('users').create(body: {
        'username': username,
        'email': email,
        'name': name,
        'birthday': birthday.toIso8601String(),
        'gender': gender,
        'role': false,
        'password': password,
        'passwordConfirm': password,
      });
      return User.fromJson(
        record.toJson()..addAll({'imageUrl': _getProfileImageUrl(pb, record)}),
      );
    } catch (error) {
      if (error is ClientException) {
        throw Exception(error.response['message']);
      }
      throw Exception('An error occurred during signup');
    }
  }

  Future<User> login(String username, String password) async {
    final pb = await getPocketbaseInstance();

    try {
      final authRecord =
          await pb.collection('users').authWithPassword(username, password);

      final imageUrl = _getProfileImageUrl(pb, authRecord.record);

      final jsonData = authRecord.record.toJson()
        ..addAll({'imageUrl': imageUrl});

      return User.fromJson(jsonData);
    } catch (error) {
      if (error is ClientException) {
        throw Exception(error.response['message']);
      }
      throw Exception('An error occurred during login');
    }
  }

  Future<void> logout() async {
    final pb = await getPocketbaseInstance();
    pb.authStore.clear();
  }

  Future<User?> getUserFromStore() async {
    final pb = await getPocketbaseInstance();
    final model = pb.authStore.record;
    if (model == null) {
      return null;
    }
    return User.fromJson(
      model.toJson()..addAll({'imageUrl': _getProfileImageUrl(pb, model)}),
    );
  }

  Future<User?> updateUser(User user) async {
    try {
      final pb = await getPocketbaseInstance();
      final userModel = await pb.collection('users').update(
            user.id!,
            body: user.toJson(),
            files: user.profileImage != null
                ? [
                    http.MultipartFile.fromBytes(
                      'profileImage',
                      await user.profileImage!.readAsBytes(),
                      filename: user.profileImage!.uri.pathSegments.last,
                    ),
                  ]
                : [],
          );
      return user.copyWith(
        imageUrl: user.profileImage != null
            ? _getProfileImageUrl(pb, userModel)
            : user.imageUrl,
      );
    } catch (error) {
      return null;
    }
  }

  Future<User?> updatePassword(String oldPassword, String newPassword) async {
    try {
      final pb = await getPocketbaseInstance();
      final currentUser = pb.authStore.record;

      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Cập nhật mật khẩu
      await pb.collection('users').update(
        currentUser.id,
        body: {
          'oldPassword': oldPassword,
          'password': newPassword,
          'passwordConfirm': newPassword,
        },
      );

      pb.authStore.clear();
      await login(currentUser.getStringValue('username'), newPassword);

      final updatedUser = await getUser(currentUser.id);
      return updatedUser;
    } catch (error) {
      if (error is ClientException) {
        throw Exception(error.response['message']);
      }
      throw Exception('An error occurred during password update');
    }
  }
}
