import 'package:flutter/material.dart';
import 'package:my_project/pages/home_page.dart';
import 'package:my_project/pages/login.dart';
import 'package:my_project/pages/sign_up.dart';
import 'package:my_project/pages/user_profile.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance App',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),
        '/profile': (context) => const UserProfilePage(),
        '/main': (context) => const HomePage(),
      },
    );
  }
}
