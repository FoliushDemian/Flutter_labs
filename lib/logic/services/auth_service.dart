import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
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

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return 'Please connect to the internet to sign up.';
    }

    const String baseUrl = 'http://10.0.2.2:8080/users';
    final response = await http.post(
      Uri.parse('$baseUrl/post'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final newUser = User(name: name, email: email, password: password);
      await _userService.saveUser(newUser);
      return null;
    } else {
      return 'Failed to register user';
    }

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
