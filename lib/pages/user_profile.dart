import 'package:flutter/material.dart';
import 'package:my_project/logic/models/user.dart';
import 'package:my_project/logic/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('lastLoggedInUser');
    if (email != null) {
      final userService = UserService();
      final user = await userService.getUser(email);
      if (user != null) {
        setState(() {
          _currentUser = user;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    final titleStyle = TextStyle(
      fontSize: isTablet ? 26 : 24,
      fontWeight: FontWeight.bold,
    );
    final emailStyle = TextStyle(
      fontSize: isTablet ? 18 : 16,
      color: Colors.grey[600],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.deepOrange,
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? screenWidth * 0.1 : 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: isTablet ? 80 : 50,
                      backgroundImage: const NetworkImage(
                          'https://via.placeholder.com/150',),
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(height: isTablet ? 30 : 20),
                    Text(_currentUser!.name, style: titleStyle),
                    SizedBox(height: isTablet ? 15 : 10),
                    Text(_currentUser!.email, style: emailStyle),
                    SizedBox(height: isTablet ? 30 : 20),
                  ],
                ),
              ),
            ),
    );
  }
}
