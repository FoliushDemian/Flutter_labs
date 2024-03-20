import 'dart:convert';
import 'package:my_project/logic/models/user.dart';
import 'package:my_project/logic/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AbstractAuthService {
  Future<String?> register(String name, String email, String password);
  Future<void> logout();
  Future<bool> login(String email, String password);
}

class AuthService implements AbstractAuthService {
  final AbstractUserService _userService = UserService();

  @override
  Future<String?> register(String name, String email, String password) async {
    if (!email.contains('@') || password.length < 6) {
      return 'Invalid input';
    }
    final existingUser = await _userService.getUser(email);
    if (existingUser != null) {
      return 'User already exists';
    }
    final newUser = User(name: name, email: email, password: password);
    await _userService.saveUser(newUser);
    return null;
  }

  @override
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(email);
    if (userString != null) {
      final userMap = jsonDecode(userString) as Map<String, dynamic>;
      if (password == userMap['password']) {
        await prefs.setString('userLogged', email);
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userLogged');
  }
}
